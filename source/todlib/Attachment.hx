package todlib;

import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sexyappbase.Graphics;
import todlib.attachment.AttachEffect;
import todlib.attachment.EffectType;

class Attachment
{
    public var effectArray:Array<AttachEffect>;
    public var dead:Bool;
    public var shakeOffset:FlxPoint;

    public function new() 
    {
        effectArray = [];
        dead = false; 
        shakeOffset = FlxPoint.get();
    }

    public function attachmentSelfDie()
    {
        for (effect in effectArray)
        {
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.reanimationDie();
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.attachmentSelfDie();
                    }

                default:
            }

            effect = null;
            effectArray.remove(effect);
        }
        
        effectArray.resize(0);
        dead = true;
    }

    public function update(elapsed:Float)
    {
        for (effect in effectArray)
        {
            var isEmpty = true;

            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null && !aReanim.dead)
                    {
                        aReanim.update(elapsed);
                        isEmpty = false;
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null && !aAttachment.dead)
                    {
                        aAttachment.update(elapsed);
                        isEmpty = false;
                    }

                default:
            }

            if (isEmpty)
            {
                effectArray.remove(effect);
            }

            if (effectArray.length == 0)
            {
                dead = true;
            }
        }
    }

    public function setPosition(position:FlxPoint)
    {
        for (effect in effectArray)
        {
            var aNewPoint = effect.offset.clone();
            aNewPoint.concat(effect.offset);

            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.setPosition(aNewPoint.tx, aNewPoint.ty);
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.setPosition(FlxPoint.get(aNewPoint.tx, aNewPoint.ty));
                    }

                default:
            }
        }
    }

    public function setMatrix(matrix:FlxMatrix)
    {
        for (effect in effectArray)
        {
            var aPosition = effect.offset.clone();
            aPosition.concat(matrix); 

            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.overlayMatrix.copyFrom(aPosition);
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        var aMatrix =  new FlxMatrix();
                        aMatrix.copyFrom(aPosition);
                        aAttachment.setMatrix(aMatrix);
                    }

                default:
            }
        }
    }

    public function overrideColor(color:FlxColor)
    {
        for (effect in effectArray)
        {
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.colorOverride = color;
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.overrideColor(color);
                    }

                default:
            }
        }
    }

    public function overrideScale(scale:Float)
    {
        for (effect in effectArray)
        {
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.overrideScale(scale, scale);
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.overrideScale(scale);
                    }

                default:
            }
        }
    }

    public function draw(g:Graphics, parentHidden:Bool)
    {
        g.pushState();
        g.trans.x += shakeOffset.x;
        g.trans.y += shakeOffset.y;

        for (effect in effectArray)
        {
            if (parentHidden && effect.dontDrawIfParentHidden)
            {
                continue;
            }
            
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.draw(g);
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.draw(g, parentHidden);
                    }

                default:
            }
        }
    }

    public function detach()
    {
        for (effect in effectArray)
        {
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.isAttachment = false;
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.detach();
                    }

                default:
            }

            effectArray.remove(effect);
        }

        effectArray.resize(0);
        dead = true;
    }

    public function propogateColor(color:FlxColor, enableAdditiveColor:Bool, additiveColor:FlxColor, enableOverlayColor:Bool, overlayColor:FlxColor)
    {
        for (effect in effectArray)
        {
            if (effect.dontPropogateColor)
            {
                continue;
            }
            
            switch (effect.effectType)
            {
                case EffectType.PARTICLE:
                case EffectType.TRAIL:
                case EffectType.REANIM:
                    var aReanim:Reanimation = effect.effect;
                    if (aReanim != null)
                    {
                        aReanim.colorOverride = color;
                        aReanim.enableExtraAdditiveColor = enableAdditiveColor;
                        aReanim.extraAdditiveColor = additiveColor;
                        aReanim.enableExtraOverlayColor = enableOverlayColor;
                        aReanim.extraOverlayColor = overlayColor;
                        aReanim.propogateColorToAttachments();
                    }

                case EffectType.ATTACHMENT:
                    var aAttachment:Attachment = effect.effect;
                    if (aAttachment != null)
                    {
                        aAttachment.propogateColor(color, enableAdditiveColor, additiveColor, enableOverlayColor, overlayColor);
                    }

                default:
            }
        }
    }

    public static function attachmentPropogateColor(attachment:Attachment, color:FlxColor, enableAdditiveColor:Bool, additiveColor:FlxColor, enableOverlayColor:Bool, overlayColor:FlxColor)
    {
        if (attachment == null)
        {
            return;
        }

        attachment.propogateColor(color, enableAdditiveColor, additiveColor, enableOverlayColor, overlayColor);
    }

    public static function attachmentUpdateAndSetMatrix(elapsed:Float, attachment:Attachment, matrix:FlxMatrix)
    {
        if (attachment == null)
        {
            return;
        }

        attachment.update(elapsed);
        attachment.setMatrix(matrix);
    }

    public static function attachmentDie(attachment:Attachment)
    {
        if (attachment == null)
        {
            return;
        }

        attachment.attachmentSelfDie();
    }

    public static function attachmentDetach(attachment:Attachment)
    {
        if (attachment == null)
        {
            return;
        }
        
        attachment.detach();
    }

    public static function attachmentDraw(attachment:Attachment, g:Graphics, parentHidden:Bool)
    {
        if (attachment == null)
        {
            return;
        }
        
        attachment.draw(g, parentHidden);
    }

    public static function findReanimAttachment(attachment:Attachment) 
    {
        if (attachment == null)
        {
            return null;
        }

        for (effect in attachment.effectArray)
        {
            if (effect.effectType == EffectType.REANIM)
            {
                var aReanimation:Reanimation = effect.effect;
                if (aReanimation != null)
                {
                    return aReanimation;
                }
            }
        }

        return null;
    }

    public static function createEffectAttachment(attachment:Attachment, effectType:EffectType, data:Dynamic, offsetX:Float, offsetY:Float) : {effect:AttachEffect, attachment:Attachment}
    {
        if (attachment == null || attachment.dead)
        {
            attachment = Main.effectSystem.attachmentHolder.allocAttachment();
        }

        var aAttachEffect = new AttachEffect();
        aAttachEffect.effectType = effectType;
        aAttachEffect.effect = data;
        aAttachEffect.dontDrawIfParentHidden = false;
        aAttachEffect.offset = new FlxMatrix();
        aAttachEffect.offset.identity();
        aAttachEffect.offset.tx = offsetX;
        aAttachEffect.offset.ty = offsetY;
        attachment.effectArray.push(aAttachEffect);

        return {effect: aAttachEffect, attachment: attachment};    
    }

    public static function attachReanim(attachment:Attachment, reanimation:Reanimation, offsetX:Float, offsetY:Float) : {effect:AttachEffect, attachment:Attachment}
    {
        var result = createEffectAttachment(attachment, EffectType.REANIM, reanimation, offsetX, offsetY);
        reanimation.isAttachment = true;
        return result;
    }

    public static function findFirstAttachment(attachment:Attachment) 
    {
        if (attachment == null)
        {
            return null;
        }

        return attachment.effectArray[0];
    }
}