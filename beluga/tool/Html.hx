package beluga.tool;

/**
 * ...
 * @author Alexis Brissard
 */
class Html
{

    public static function tag(tagname : String, attrList : Map<String, String>, ?content : String) {
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