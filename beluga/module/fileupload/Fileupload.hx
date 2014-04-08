package beluga.module.fileupload;

import beluga.core.module.Module;

interface Fileupload extends Module {
	public function browse(): Void;
}