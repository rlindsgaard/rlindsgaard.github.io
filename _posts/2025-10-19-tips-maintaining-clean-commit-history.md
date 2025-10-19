---
layout: post
title: "Tips to Maintaining a Clean Commit History as an Individual Contributor"
categories:
 - "Software Engineering"
---

All the tips presented here is neither ground-breaking or new in any way. It is anything but, and the internet is filled with references on either topic (I took the liberty of linking to my favorites throughout the post).

What might be new, is my audacious attempt to provide a suggested priority or order in which to apply. I tried crystalizing the effort into concrete actionables that, in my humble opinion, yields the highest reward. 

My intended audience is anyone I just so happen to think might benefit from reading these thoughts on the subject by linking them directly, shamelessly promoting my own thoughts - and, of course, any random developer passing by searching to hone his or her skillset. 

## Tip #1: Rebase Early, Rebase Often
This tip placed at the top as it exposes you to any troubles as early as possible - merge conflicts are hell, but the larger the diff gets, the less likely you are able to resolve it and the more likely you will have wasted your time trying or applied a poor remedy. 

Rebase your current work at least a couple of times a day, e.g. when you sit down at the start of your day and immediately after lunch. Personally I normally rebase on main prior to pushing anything remotely.

My favorite command (aliased I call it `refresh`) is `git pull --rebase --autosquash --autostash` this makes rebasing non-intrusive on my dirty worktree.


## Tip #2: Keep Commits (and Merge Requests) Small
Iterate functionality in the smallest way possible - stay on-point in your Merge Request (MR) and prefer to make more MRs. (I know, if review process is slow this is a pain, but then that pain needs to be addressed as a cultural/practical problem).

In general, you shouls consider that the more lines of code changed makes you more susceptible to merge conflicts (and your risk conflicting with the works of others).

- Keep style and cleanup changes not directly related to your changes i.e. separate from feature work. 
- Keep the number of changes and files in a commit down.
- Keep the number of commits in an MR down.
- Keep commits atomical (i.e. a particular change in the MR should be revertable without affecting other code)
- Write your changes so they can be integrated and work in isolation without being "activated" - i.e. add your library function and tests, then in isolation you can add the call site code.
- Use `-p` when adding changes, this will allow you to review and partially add changes in a file. (note that you cannot add untracked files with this option).

Kent Beck’s Tidy First is highly recommended reading, I have spent over a decade practicing good commit structure, still this book took me to a whole new level of thinking about when and how to structure my efforts.


## Tip #3: Use Descriptive Commit Messages

In the ideal world we complete a task, switch context and then complete another one. In the real world, we switch contexts all the time - sometimes it is other work taking precedence forcing us to switch, sometimes it is time off due to weekends or vacation.

Pay it forward to your future self and practice being explicit in words giving a summary and your current reasoning for making a particular change.

Even more important is to write down what is currently *not* working or missing (so that you do not come back after an extended period of time, thinking work is complete and merge it to find out you entirely missed everything but the golden path). 

I love pointing to https://commit.style/ and
https://dhwthompson.com/2019/my-favourite-git-commit as good short examples where https://cbea.ms/git-commit covers the good commit message in depth. 
I also recommend adopting something akin to https://www.conventionalcommits.org/en/v1.0.0/ - not for the properties of parsing and automating generation of changelogs but for the purpose of ensuring all important pieces of information for posteritys sake are somewhat added the commit message.


If you think this sound like a lot of work, then then at first you maybe right - this brings me to tip #4.

## Tip #4: Learn to Rewrite Branch History

Consider commits on a branch as "staged" changes - they are up for revision until they hit the main branch, in terms of content, description, and order for that matter - learn to quickly do history re-writes, the more you do it, the more second nature it becomes. Here is a selection of such re-writes I use on a daily to weekly basis.

See also https://about.gitlab.com/blog/keeping-git-commit-history-clean/ for some more in-depth explanation of my presented scenarios. As an aside https://ohshitgit.com/ explains a number of ways to get you out of any pickle you are bound to get yourself into trying out these things.

### Add a missing file/change to the last commit 
`git commit --amend --reuse-message=HEAD` will commit any changes currently staged. I alias it `git fix`

### Add a missing file/change to a previous commit.  
Assuming the changed is staged, use `git log` or similar to find the subject commit sha. Then `git commit --fixup <commit-sha>`. This will add a commit with a special message to your history and you don't have to think of a commit message. Use `git rebase main --autosquash` to patch the target commit (or `git rebase -i main --autosquash` if you want to inspect the order first)


### I need this bugfix to continue my work but it is unrelated

Commit the change here and now to `feature-branch`, then checkout another branch from main and use `git cherry-pick feature-branch` (as long as the commit is the one on top cherry pick will do this) - push this fix and create an MR - continue working on feature branch and when the fix ME is merged, the bugfix change commit will automatically be removed from `feature-branch` upon rebase as it is empty.


### I Have Multiple Commits That When Squashed Finally Works

Using `git rebase -i main` - I prefer the mechanism where squashes are made by `fixup` actions on subsequent commits (usually the first commit contains the description I wanted in the first place). Sometimes I `reword` the first one.

Sometimes this gets hairy, especially if you placed other changes in between - I then first go for multiple iterations i.e. using the rebase command over and over selecting only a subset of the changes to fix/squash each time.

If that doesn't help I take on more drastic measures not covered here.


### This change was placed in the wrong commit

Assuming there are no subsequent changes causing merge conflicts, `git rebase -i main` and select `edit` for the commit. 

Rebase will now halt `git restore -p --staged <filename>` until the staged changes look like the commit you want. The remainding changes are left unstaged now.

Then `git rebase --continue`. Now the accidentally committed changes can be added to the appropriate commits.

Pro tip: Rebasing is just an operation that replays a set of commits onto a new base branch - you can even make new commits while performing this operation.


## Tip #5: Learn the Internals of Git

You don’t have to like working in the command line or even be able to get yourself out of any particular jam - but you need to invest time understanding the basics and the internals of Git. Most important is knowing the concepts and terminology just for the purpose of googling and prompting to get yourself out of a rot. Pro Git is available for free https://git-scm.com/book/en/v2 and is recommended reading for anyone working profesionally with software development.

In the end, nothing replaces learning the commands and their flags little by little with the help of the command line output and a manual.


## Wrapping Up
You don’t get good without greasing the groove. It might feel like a lot of work up front, but down the line this knowledge will save you headaches and redoing work. You are likely stuck with git as the defacto version control system for any foreseable future - and when the time comes, these lessons apply to the new tool as well. Any time invested upskilling in version control will be sure to pay itself back over and over during the course of the next decade(s) you don’t need to go the full mile instantly, just use this to consider where your next 1% improvement might be.