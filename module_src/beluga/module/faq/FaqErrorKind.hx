// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.faq;

enum FaqErrorKind {
    UnknownCategory;
    MissingQuestion;
    MissingAnswer;
    MissingName;
    MissingLogin;
    EntryAlreadyExists;
    CategoryAlreadyExists;
    IdNotFound;
    None;
}