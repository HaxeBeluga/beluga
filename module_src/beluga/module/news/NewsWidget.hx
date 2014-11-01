package beluga.module.news;

import beluga.module.news.widget.Default;
import beluga.module.news.widget.Create;
import beluga.module.news.widget.Print;
import beluga.module.news.widget.Edit;

class NewsWidget {
    public var news = new Default();
    public var create = new Create();
    public var print = new Print();
    public var edit = new Edit();

    public function new() {}
}