// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.survey.model.SurveyModel;

@:table("beluga_sur_choice")
@:id(id)
@:build(beluga.Database.registerModel())
class Choice extends Object {
    public var id : SId;
    public var label : STinyText;
    public var survey_id : SInt;
    @:relation(survey_id) public var survey : SurveyModel;
}