package todlib;

import todlib.attachment.AttachmentHolder;
import todlib.reanimator.ReanimationHolder;
import todlib.todparticle.TodParticleHolder;

class EffectSystem 
{
    public var particleHolder:TodParticleHolder;
    //
    public var reanimtionHolder:ReanimationHolder;
    public var attachmentHolder:AttachmentHolder;

    public function new() {}

    public function effectSystemInitialize() 
    {
        Main.effectSystem = this;

        particleHolder = new TodParticleHolder();
        reanimtionHolder = new ReanimationHolder();
        attachmentHolder = new AttachmentHolder();

        particleHolder.initializeHolder();
        reanimtionHolder.initializeHolder();
        attachmentHolder.initializeHolder();
    }

    public function effectSystemDispose() 
    {
        reanimtionHolder.disposeHolder();
        reanimtionHolder = null;
        attachmentHolder.disposeHolder();
        attachmentHolder = null;
        
        Main.effectSystem = null;
    }

    public function processDeleteQueue()
    {
        for (particle in particleHolder.particleSystems)
        {
            if (particle.dead)
                particleHolder.particleSystems.remove(particle);
        }

        for (reanim in reanimtionHolder.reanimations)
        {
            if (reanim.dead)
                reanimtionHolder.reanimations.remove(reanim);
        }

        for (attachment in attachmentHolder.attachments)
        {
            if (attachment.dead)
                attachmentHolder.attachments.remove(attachment);
        }
    }

    public function update(elapsed:Float)
    {
        for (particle in particleHolder.particleSystems)
        {
            if (!particle.isAttachment)
                particle.update(elapsed);
        }

        for (reanim in reanimtionHolder.reanimations)
        {
            if (!reanim.isAttachment)
               reanim.update(elapsed);
        }
    }
}