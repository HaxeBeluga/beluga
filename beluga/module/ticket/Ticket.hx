package beluga.module.ticket;

import beluga.core.module.Module;

/**
 * Description of the ticket system.
 * 
 * @author Valentin & Jeremy
 */
interface Ticket extends Module {
	public function browse(): Void;
	public function create(): Void;
	public function getBrowseContext(): Dynamic;
	public function getBrowseCreate(): Dynamic;
	public function getBrowseShow(): Dynamic;
}