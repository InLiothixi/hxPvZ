package todlib.attachment;

class AttachmentHolder
{
    public var attachments:Array<Attachment>;

    public function new() {}

    public function initializeHolder()
    {
        attachments = [];
    }

    public function disposeHolder()
    {
        for (member in attachments)
        {
            member.attachmentSelfDie();
            attachments.remove(member);
        }

       attachments = null;
    }

    public function allocAttachment()
    {
        var attachment = new Attachment();
        attachments.push(attachment);
        return attachment;
    }
}