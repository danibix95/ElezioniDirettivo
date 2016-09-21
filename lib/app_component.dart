// Copyright (c) 2016, danibix95. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/common.dart' show CORE_DIRECTIVES;
import 'package:angular2/core.dart';

@Component(
    selector: 'directiveElection',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [CORE_DIRECTIVES]
)
class AppComponent {
  List<Candidate> candidates = new List();
//  List<String> ciao = ["a", "b", "c"];

  void addCandidate() {
    var iname = querySelector("#name") as InputElement;
    var isurname = querySelector("#surname") as InputElement;

    if(iname.value != "" && isurname.value != "") {
      candidates.add(new Candidate(iname.value, isurname.value));

      // for debug
//      candidates.forEach((c) {
//        print("${c.name} ${c.surname} ${c.votes}");
//      });

      // resets fields
      iname.value = "";
      isurname.value = "";
    }
  }

  void removeCandidate(String name, String surname) {
    print("Trying to remove $name $surname");

    candidates.removeWhere((c) => c.name == name && c.surname == surname);
  }

  void clearCandidateList() {
    candidates.clear();
  }

  void selectElected() {
    candidates.sort((a, b) => -a.votes.compareTo(b.votes));
  }
}

class Candidate{
  String name;
  String surname;
  int votes = 0;

  void incVotes() {
    votes++;
  }
  void decVotes() {
    if (votes > 0) votes--;
  }

  String toString() => "Candidato: $name $surname - Voti: $votes";

  /// Generate a candidates with a name, surname and 0 votes by defaults
  Candidate(String this.name, String this.surname);
}