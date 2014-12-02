package beluga.html;

import beluga.resource.ResourceManager;
import haxe.Template;
import Type;
import beluga.tool.DynamicTool;

class TypeGenerator
{

    private static function generate_obj(value : Dynamic, name : String, names : Array<String>) {
        var html = "";
        var tpl = ResourceManager.getTpl("/beluga/html/type_template/Object.mtt");
        for (field_name in Reflect.fields(value)) {
            var field_value = Reflect.field(value, field_name);
            html += rec_parse(field_value, field_name, names);
        }
        return tpl.execute( {
            labe: name,
            name: DynamicTool.toDottedName(names),
            value: value,
            content: html
        });
    }

    private static function generate_type(value : Dynamic, name : String, names : Array<String>, tpl : Template) {
        return tpl.execute( {
            label: name,
            name: DynamicTool.toDottedName(names),
            value: value
        });
    }

    private static function rec_parse (value : Dynamic, ?name : String, names : Array<String>) {
        var html = "";
        if (name != null) names.push(name);
        var type = generate_type.bind(value, name, names);
        var obj = generate_obj.bind(value, name, names);
        html += switch(Type.typeof(value))
        {
            case TInt: type(ResourceManager.getTpl("/beluga/html/type_template/Int.mtt"));
            case TFloat: type(ResourceManager.getTpl("/beluga/html/type_template/Float.mtt"));
            case TBool: type(ResourceManager.getTpl("/beluga/html/type_template/Boolean.mtt"));
            case TClass(String): type(ResourceManager.getTpl("/beluga/html/type_template/String.mtt"));
            case TClass(_): obj();
            case TObject: obj();
            case _: "";
        }
        names.pop();
        return html;
    }
    
    public static function parse(value : Dynamic, ?name : String)
    {
        return rec_parse(value, []);
    }
    
}