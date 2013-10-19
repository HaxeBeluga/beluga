package ;

/**
 * ...
 * @author Masadow
 */
class View
{

	public var name : Null<String>;
	public var context : Dynamic;
	
	public function new() 
	{
		context = { };
		context.view = Array<View>();
		name = null;
	}
	
	public function add(subview : View)
	{
		if (subview.name != null) {
			context.view.push(subview);
		}
	}
	
	public function render(print : Bool)
	{
		var html = "";
		
		//#if templo
			//html = "Templo";
		//#else
			//html = "Not templo";
		//#end
		//Should we let user to choose rendering engine ?
		
		
		
		if (print) {
			Sys.print(html);
		}
	}
	
}