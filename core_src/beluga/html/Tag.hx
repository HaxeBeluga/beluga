package beluga.html ;

class Tag
{
    public var tagname : String;
    public var attrList : Map<String, String>;
    public var content : String;

    public function new(tagname : String, attrList : Map<String, String>, ?content : String) {
        this.tagname = tagname;
        this.attrList = attrList;
        this.content = content;
    }
    
    public function toString() {
        var html = "<" + tagname;
        for (attrName in attrList.keys()) {
            html += " " + attrName + "=\"" + attrList[attrName] + "\"";
        }
        if (content != null) {
            html += ">";
            html += content;
            html += "</" + tagname + ">";
        } else {
            html += "/>";
        }
        return html;
    }

}