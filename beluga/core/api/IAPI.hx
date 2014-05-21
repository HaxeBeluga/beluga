package beluga.core.api;

import beluga.module.account.api.AccountApi;
import beluga.core.Beluga;

/**
 * This class is needed to trigger autoBuild.
 * @author Masadow
 */
@:autoBuild(beluga.core.api.APIBuilder.build())
interface IAPI<Module>
{
	public var beluga : Beluga;
	public var module : Module;
}