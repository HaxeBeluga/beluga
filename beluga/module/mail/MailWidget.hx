package beluga.module.mail;

import beluga.module.mail.widget.Default;
import beluga.module.mail.widget.Create;
import beluga.module.mail.widget.Print;

class MailWidget {
    public var mail = new Default();
    public var create = new Create();
    public var print = new Print();

    public function new() {}
}