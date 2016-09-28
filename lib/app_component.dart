// Copyright (c) 2016, Daniele Bissoli - danibix95. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

import 'package:angular2/common.dart' show CORE_DIRECTIVES, FORM_DIRECTIVES;
import 'package:angular2/core.dart';

@Component(
    selector: 'directiveElection',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES]
)
class AppComponent {
  String iName = "";
  String iSurname = "";
  List<Candidate> candidates = new List();

  /// Add new candidate to candidates list
  void addCandidate() {
    if (iName != "" && iSurname != "") {
      candidates.add(new Candidate(iName, iSurname));

      // resets fields
      iName = "";
      iSurname = "";

      // update or create a local copy of candidates list
      saveCandidates();

      // focus on name input field
      querySelector("#name").focus();
    }
  }

  // Remove selected candidate
  void removeCandidate(String name, String surname) {
    candidates.removeWhere((c) => c.name == name && c.surname == surname);
    saveCandidates();
  }

  /// Remove all candidates from current list
  void clearCandidateList() {
    candidates.clear();
    // clear windows storage
    window.localStorage.clear();
  }

  /// Rearrange list according to most voted candidate
  void selectElected() {
    candidates.sort((a, b) => -a.votes.compareTo(b.votes));
    saveCandidates();
  }

  /// Save candidates list on browser local storage
  void saveCandidates() {
    window.localStorage['candidates'] = JSON.encode(candidates);
  }

  /// Build app component
  ///
  /// Build app and populate candidates list from local storage if there are some data.
  /// Moreover sort list for votes number in descending way.
  AppComponent() {
    if (window.localStorage.containsKey('candidates')) {
      JSON.decode(window.localStorage['candidates'])
          .forEach((c) => candidates.add(new Candidate.fromJSON(c)));
      selectElected();
    }
  }
}
/// A Candidate is representation of person who the meeting has to choose as leader.
class Candidate {
  /// The name of this candidate
  String name;
  /// The surname of this candidate
  String surname;
  /// The number of votes this candidate had received
  int votes;

  /// increase candidate's votes
  void incVotes() {
    votes++;
  }

  /// decrease candidate's votes if they are great than 0
  void decVotes() {
    if (votes > 0) votes--;
  }

  String toString() => "$name $surname";

  /// convert Candidate object to Map object representing it as JSON
  Map toJson() => { "name" : name, "surname" : surname, "votes" : votes };

  /// Generate a candidate with a name, surname and 0 votes by defaults
  Candidate(String this.name, String this.surname) : votes = 0;

  /// Generate a candidate using information contained into passed Map
  Candidate.fromJSON(Map candidate) {
    name = candidate['name'];
    surname = candidate['surname'];
    votes = candidate['votes'];
  }
}