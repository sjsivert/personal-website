Finally your code is approved after 5 "qa: Fix" commits. How does the road to production look like from here? 
A friend of mine works on a project with a really complicated Git flow setup, and strict military grade ritual the code has to follow, before it hopefully one day can pack itself on the back with title "code in production". The process was something like this: The code gets merged into a feature branch, once the feature branch, is done the ...

- Brancher feature branch ut fra main (prod). 
- lager proxy branch ut fra feature branch
- merger develop inn i proxy branch
- lager PR og merger proxy branch inn i develop som deretter deployes til dev miljø
- lager PR fra feature branch til main
- flytter issue i Jira til Code review, sender link til Gitlab PR på Teams
- Etter approval flytte issue til Ready for test i Jira og Gitlab kjører auto merge til test branch (test miljø)
- Etter godkjent av tester, flytter tester issue til "passed test" i Jira.
- Får label "Passed test" på PR til main i Gitlab, og det merges og deployes til prod

This over complicated dance of a ritual is called [gitflow](https://danielkummer.github.io/git-flow-cheatsheet/). It was the meta back in the days, and proberly is in some god forsaken companies today, where the mean age of developers is above 50. The cool kids use [trunk-based development today](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development). 


~~It's hard to overstate how much I adore fast compile times, which is the main reasons I'm  interested in the Go programming language. Go compiles so fast it deserves its own mini-tribute:~~
- ~~Go compiles so fast, by the time you blink, it’s already chilling in production.~~
- ~~Go compiles so fast, I once hit "build," and it was done before my hand left the keyboard.~~
- ~~Go compiles so fast, waiting for it is like waiting for instant noodles—minus the three minutes.~~
- ~~Go compiles so fast, that the most popular third party templating library Templ, gets does typoesafity compile time, by first compiling the projects Go code, and then analysing the binary (this one is actually true). (TODO: FInd a source for this)~~

The shortest 
- Techincal debt
- When doing PRs
- Getting things into production
- Allow work outside the scrum loop
+ Githubs new featuers