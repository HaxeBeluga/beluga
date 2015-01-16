// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group;

import beluga.trigger.Trigger;
import beluga.trigger.TriggerVoid;

import beluga.module.group.GroupErrorKind;

import sys.db.Types;

class GroupTrigger {
    public var groupCreationSuccess = new TriggerVoid();
    public var groupCreationFail = new Trigger<{error: GroupErrorKind}>();
    public var groupDeletionSuccess = new TriggerVoid();
    public var groupDeletionFail = new Trigger<{error: GroupErrorKind}>();
    public var groupModificationSuccess = new TriggerVoid();
    public var groupModificationFail = new Trigger<{error: GroupErrorKind}>();
    public var memberAdditionSuccess = new TriggerVoid();
    public var memberAdditionFail = new Trigger<{error: GroupErrorKind}>();
    public var memberRemovalSuccess = new TriggerVoid();
    public var memberRemovalFail = new Trigger<{error: GroupErrorKind}>();

    public function new() {}
}