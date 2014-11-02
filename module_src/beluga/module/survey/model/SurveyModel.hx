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

import beluga.module.account.model.User;

@:table("beluga_sur_survey")
@:id(id)
@:build(beluga.Database.registerModel())
class SurveyModel extends Object {
    public var id : SId;
    public var name : SString<128>;
    public var status : SInt;
    public var date_start : SDate;
    public var date_end : SDate;
    public var description : SText;
    public var author_id : SInt;
    public var multiple_choice : SBool; // true if the survey accepts multiple answer, false otherwise
    @:relation(author_id) public var author : User;
}