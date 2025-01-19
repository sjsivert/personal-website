---
title: Developer Joy
author: Sindre J.I Sivertsen
date: 2024-11-17 00:34:00 +0800
categories:
  - Opinion
tags:
  - favicon
---

In 2023, I attended a talk by Sven Peters from Atlassian titled _"Developer Joy - How Great Teams Get Sh%\*t Done"_ ([It’s a fantastic talk—you should check it out](https://www.youtube.com/watch?v=0wEmyhp6zK4)).
Developer productivity, according to Atlassian, is best measured through 'developer joy.'
If organizations want to boost productivity in their engineering teams, their focus should be on fostering developer joy.

As a developer, I love the sound of this. At first glance, it sounds like the best productivity strategy might involve management buying everyone pizza, installing a foosball table, and setting up emoji feedback buttons by the office exit—like the ones at airport security. I mean, it couldn’t hurt, right? But, unfortunately for my dreams of endless pizza, that’s not what Atlassian meant.

Atlassian defines developer joy through three simple pillars: dev quality, dev progress, and dev value.

- **Dev quality:** If I feel the code I’m writing is clean, well-crafted, and of high quality, then I’m scoring high on dev quality.
- **Dev progress:** If the process of taking a task from the board to production is smooth and free of blockers, the team scores high on dev progress.
- **Dev value:** If my work feels meaningful and valuable to others, it scores high on dev value.

In other words, developers thrive on feeling productive. If an organization focuses on improving developer experience, enhancing tooling, and reducing friction, developers will naturally become more productive.

While this interpretation sadly doesn’t include a foosball table, I still love it. Since the conference, I’ve thought a lot about the topic, and I’ve realized that for me personally, _short feedback loops_ are a key component for a high **dev progress** score. Sven talked about dev progress in the context of big team processes. That is indeed important, but the idea can, and should be applied to all parts of software development.

Software development is all about iteration and feedback loops. A feedback loop measures how long it takes to get confirmation on whether your latest work is on the right track or headed for a detour. The smaller the feedback loop, the faster you can iterate, keeping you firmly in the flow. And as developers, we know that maximizing time in the flow state is key.

Slow feedback loops, on the other hand, range from mildly frustrating to downright exhausting. At best, they drain your energy; at worst, they can lead to months of wasted effort and man-hours.

In this article, I’ll dive into different types of feedback loops and explore ways to shrink them down as much as possible.

## The code

Writing code is an iterative process, and let’s be honest—most of the time, when you stop typing, you’re greeted by the dreaded red line. Over the years, though, I’ve come to appreciate that red line as the best feedback buddy a developer could ask for. Instantly, you know if what you’ve written is spot-on or wildly off. If it’s not correct, you even get a handy description of what went wrong (along with a gentle nudge to fix it).

This red line is all thanks to static code analysis, handled by the compiler. For compiled languages, like C# with the Roslyn compiler, static analysis is part of the compiler’s job, catching issues early. How much help you get from your code editor depends a lot on your language of choice. Strongly typed languages like C# and TypeScript offer tons of insights on potential issues before a single line executes, while dynamic languages like Python and JavaScript can mostly catch errors related to incorrect syntax.

Some languages can tighten up the feedback loops by disallowing null pointers—one of Kotlin’s big advantages over Java. Or consider enforced error handling in languages like Rust and Go, where every function call requires a plan for failure before your code is considered valid. Generally, the stricter the compiler, the more errors can be avoided at runtime, resulting in a shorter feedback loop. After all, it’s far better to handle an edge case today than track down a bug in production a month from now.

Unfortunately, thanks to the famous [halting problem](https://brilliant.org/wiki/halting-problem/), some issues are beyond a compiler’s reach. That brings us to the next feedback loop: running the code itself.

Here, compile time is an obvious bottleneck. When you’re working on something that demands lots of small tweaks—like CSS—even a compile time over two seconds can test the patience of the most zen programmers after a while.

There are ways to speed up compile times depending on the language. In JavaScript, you can swap out webpack with Bun or Turbopack. Iteratively compiled languages like C# and Java can benefit from shared build cache servers. Another option to speed things up is by doing _less_ static analysis (but we’re not quite that desperate!). Another quality-of-life boost is _live code updates_, where changes are instantly reflected without needing a full recompile.

When compile times start dragging on long enough for developers to grow gray beards waiting, the go-to solution is often to split a monolithic codebase into multiple, independently deployable services. This can give a shorter feedback loop initially, but it may eventually cost you with a longer feedback loop [in the long run](https://www.youtube.com/watch?v=LcJKxPXYudE).

But let’s say you’re writing a new REST endpoint for your large monolith in a language that’s not Go. You’re in a strongly-typed language, like C#, but with a hefty 10-second compile time. Every time you want to run the code, you’re stuck waiting, so you pop over to Postman and start spamming the send request button just to pass the time. This feedback loop drags on, and after a while, it’s downright exhausting.

A simple way to tighten this loop? Write a test. Unit tests in iteratively compiled languages can run much quicker than the program itself, since the compiler only needs to compile the test itself and any assemblies it relies on. Plus, you won’t be flipping back and forth between your IDE and Postman.

Writing a test early on is an investment that pays off both short-term, while you’re building the code, and long-term, when someone else (or future you) makes changes. For me, putting in a bit of effort upfront to keep the feedback loop fast is always worth it!

---

## The pull request

You (think) you’re done writing some code, and it’s time to share it with the world—or at least with the team. For a software developer, that means creating a pull request and bracing yourself for code review. But before you want to request a review from that senior developer that always catch you in doing silly mistakes you wished you found yourself before requesting a review, you should wait for the required pipelines to go green. The art of writing speedy pipelines deserves a post of it's own, but in short:

- Don't do steps in the order that feels natural, eg, lint, build, unit tests, e2e tests. Run the pipeline in order of dependency, and optimize the pipeline to fail fast. If that means running the e2e test right after the build step, do it.
- Use caching as much as possible.
- Run things in parallel when possible.
- A pipeline that runs longer than 10 minutes is too long.
  I recommend this NDC talk on this topic : [CI/CD Patterns and antipatterns](https://www.youtube.com/watch?v=OonABHdHD2I&t=1214s).

Unlike the solo speed of coding, code review slows things down because it depends on others. Keeping a snappy feedback loop in the code review process is all about team culture: the team should prioritize pull requests above _almost_ everything else. After all, the main goal of a team is to deliver value to users or the company through the code they create. And a pull request represents code that’s closer to the finish line than whatever you’re currently working on. So, the fastest way you can add value is actually by reviewing your co-worker’s code—giving them the green light so they can ship it!

There are steps to ease the pain of context switching away from what you are currently doing, over to running and reviewing someones code. I once worked on a team developing a mobile app with React Native, and every time we fired up the iOS simulator, we faced a dreaded two-step authentication before even getting to the home screen. It was a step we went through maybe three times a day, tops. But the mental toll it took was huge. I noticed my teammates were more reluctant to do pull requests, and honestly, I started skipping the process of running the code on my device just to avoid the login.

Then, one day, a coworker added a simple if-statement to fetch credentials from an .env file whenever we ran the code in dev mode. He probably spent a day on it, tops. Now, you could argue that the time he spent didn’t really balance out the time we wasted manually logging in each time. But, let me tell you, this autologin feature was a game-changer. With that login barrier gone, we could switch branches and collaborate way more freely. It was easier to run each other’s code, which meant code quality went up, bugs got caught earlier, and everyone was happier (and probably a little more sane).

Another example was when our team was building a Microsoft Teams bot. The setup process for our local dev environment was… well, let’s just say it was a ritual in itself:

1. Fire up a reverse proxy tunnel with devtunnel.
2. Grab the reverse proxy URL and update the Teams bot configuration in Azure to point to that specific URL.
3. Update not one, but two separate `launchSettings.json` files locally.
4. Modify a database row (also locally, of course).

Now, whenever we switched gears from the Teams bot to backend business, we had to backtrack through every single one of these steps. For weeks, we’d repeat this four-step dance manually, over and over, before it finally dawned on me—_this could be automated with a simple bash script_. Half a day later, I had a script that would’ve saved us all so much time and probably should have been created ages ago.

Streamlining code reviews should be a top priority for any team. Small actions can make a huge difference. For example, including a screenshot or video in a pull request can quickly give reviewers the context they need. And for any UI changes, nothing beats a temporary preview of the website—pure magic for a reviewer! Hosting platforms like Vercel and Netlify, and Expo have nailed this with their instant, no-setup preview feature. It’s practically a life-saver and likely one of the big reasons they’re so popular in the world of SaaS hosting. A small feature GitHub just released is a plugin for VS Code that lets you do pull requests from within VS Code. A small feature, but I personally found it gave huge value.

There are many more feedback loops in the life of a software developer. But this post is getting long, and I don't have enough experiences under my belt yet to comment on them all.
Each example I have talked about reinforces one central truth: shorter feedback loops lead to happier, more productive developers.

When feedback comes quickly, you stay in the flow, maintain momentum, and feel a sense of progress. It’s no surprise that “developer joy” hinges on improving these loops—making tools faster, processes smoother, and collaboration easier.

Shortening feedback loops isn’t just about boosting individual productivity; it’s about creating an environment where teams can deliver value effectively. Whether it’s automating the small stuff, streamlining processes, or prioritizing code reviews, every improvement feeds into a culture of efficiency and satisfaction. I feel fortunate to work at a company that values developer joy and gives us the time to invest in it. I know many friends in the industry who aren’t as lucky, and it makes me appreciate this focus even more.

So, as you continue your work as a developer, ask yourself: where can feedback loops be shortened? Where can friction be reduced? Every small change adds up, and the payoff—both for you and your team—will be well worth the effort.

---
