package beluga.module.notification;

import beluga.core.module.Module;
import beluga.module.notification.model.NotificationModel;

/**
 * @author Guillaume Gomez
 */

interface Notification extends Module
{
	public function print(args : {id : Int}) : Void;
	public function create(args : {
		title : String,
		text : String
	}) : Void;
	public function delete(args : {
		id : Int}) : Void;
	public function getNotifications() : Array<NotificationModel>;
}