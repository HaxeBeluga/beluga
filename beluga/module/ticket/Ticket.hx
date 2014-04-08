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
	public function show(args: { id: Int }): Void;
	public function reopen(args: { id: Int }): Void;
	public function close(args: { id: Int }): Void;
	public function getBrowseContext(): Dynamic;
	public function getCreateContext(): Dynamic;
	public function getShowContext(): Dynamic;
}