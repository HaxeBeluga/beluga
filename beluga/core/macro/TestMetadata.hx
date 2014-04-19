package beluga.core.macro;

/**
 * ...
 * @author regnarock
 */
class TestMetadata
{

	@toto(1)
	static var test2 = 1;
	
	public function new() 
	{
		
	}

	@trigger("test_module_trigger")
	public static function test()
	{
		
	}
	
}