package lawn;

import lawn.cutscene.GameScenes;
import lawn.plant.SeedType;
import todlib.TodCommon;
import todlib.todcommon.TodCurves;

class SeedPackets extends GameObject {
    public static final SLOT_MACHINE_TIME = 400;
    public static final CONVEYOR_SPEED = 4;

    public var refreshCounter:Float;
    public var refreshTime:Float;
    public var index:Int;
    public var offsetX:Float;
    public var packetType:SeedType;
    public var imitaterType:SeedType;
    public var slotMachineCountDown:Float;
    public var slotMachiningNextSeed:SeedType;
    public var slotMachiningPosition:Float;
    public var active:Bool;
    public var refreshing:Bool;
    public var timesUsed:Int;

    override public function new() {
        super();

        slotMachiningPosition = 0;
        packetType = SeedType.NONE;
        imitaterType = SeedType.NONE;
        index = -1;
        slotMachiningNextSeed = SeedType.NONE;
        width = 50;
        height = 70;
        refreshCounter = 0;
        refreshTime = 0;
        refreshing = false;
        active = false;
        offsetX = 0;
        slotMachineCountDown = 0;
        timesUsed = 0;
    }

    public function pickNextSlotMachineSeed() {

    }
    
    public function slotMachineStart() {
        slotMachineCountDown = 3;
        slotMachiningPosition = 0;
        pickNextSlotMachineSeed();
    }
    
    public function flashIfReady() {

    }

    public function activate() {
        active = true;
    }

    public function deactivate() {
        active = false;
        refreshCounter = 0;
        refreshTime = 0;
        refreshing = false;
    }

    public function setActive(active:Bool) {
        if (active) {
            activate(); 
        }
        else {
            deactivate();
        }
    }

    public function update(elapsed:Float) {
        if (app != null && app.gameScene != GameScenes.PLAYING || packetType == SeedType.NONE) {
            return;
        }

        if (board.mainCounter == 0) {
            flashIfReady();
        }

        if (!active && refreshing) {
            refreshCounter += elapsed;
            if (refreshCounter > refreshTime) {
                refreshCounter = 0;
                refreshing = false;
                activate();
                flashIfReady();
            }
        }

        if (slotMachineCountDown > 0) {
            slotMachineCountDown -= elapsed;
            var flipsPerSecond = TodCommon.todAnimateCurve(SLOT_MACHINE_TIME, 0, slotMachineCountDown, 0.06, 0.02, TodCurves.LINEAR);
            slotMachiningPosition = flipsPerSecond;

            if (slotMachiningPosition >= elapsed) {
                packetType = slotMachiningNextSeed;
                if (slotMachineCountDown == 0) {
                    activate();
                    slotMachiningPosition = 0;
                } else {
                    slotMachiningPosition -= elapsed;
                    pickNextSlotMachineSeed();
                }
            } else if (slotMachineCountDown == 0) {
                slotMachineCountDown = elapsed;
            }
        }
    }
}