// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.module;

// beluga
import beluga.core.module.Repository;

// spod
import sys.db.Object;


class SpodRepository<Model: Object> implements Repository<Model> {
    public function new() {}

    public function save(model: Model) {
        model.insert();
    }

    public function delete(model: Model) {
        model.delete();
    }

    public function update(model: Model) {
        model.update();
    }
}