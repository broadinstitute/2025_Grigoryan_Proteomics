# 2025_Grigoryan_Proteomics
Repo for analysis of the Nomic Bio proteomics pilot data, collected as part of the OASIS Consortium.

## Repo structure

## How to contribute
Fork the repo (click the 'Fork' button in the top right), clone the fork to your local computer, and create a new branch:
```
git clone https://github.com/<YOUR-USERNAME>/2025_Grigoryan_Proteomics.git
cd ./2025_Grigoryan_Proteomics
git checkout -b branch-name
```

It is good practice to create a new branch for each task / contribution that you will make to the overall repository. For example, you might create a branch "make-summary-figure" to add a script that reads in data and creates a nice figure for the manuscript. Once you've made the changes in your local repo, commit and push the contributions:
```
git add .
git commit -m "create summary figure"
git push
```
Note that the first time that you try and push, you will get an error. Git will suggest a slightly different command - follow their suggestions. After this is run once, you can use plain `git push` in the future. 

In the Github web interface, navigate to your branch within your repo. Click the "Contribute" dropdown and then the "Open pull request" button. This will make a request to the main parent repository to merge the changes that you've contributed on your branch. It's good practice to have someone review your contributions and request any necessary edits before merging into the parent repository. Tag another repository contributor in the "Request Review" section. Once they've approved the merge, delete your branch.

If you'd like to learn more about how git and github work, Jess suggests [this lecture](https://missing.csail.mit.edu/2020/version-control/) or [this online game](https://learngitbranching.js.org/). 
