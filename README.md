# bigdata

Welcome to the github repository for Big Data Post-Module Assignment CADMS team

Instructions: 

1. Create a github account if you don't have one by going to www.github.com or downloading github desktop

2. In terminal/console/iterm2, go to a location of your preference and issue the following command:

`git clone https://github.com/caariasr/bigdata.git` 

Or you can got to File/Clone Repository in the github desktop

2. Get in that new folder with 

`cd bigdata`

In terminal/console/iterm2

3. Issue the following command 

`git checkout -b carlos` 

but instead of `carlos` use your name. Or got to Branc/New Branch in the github desktop and create a new one with your name.

4. Now You can now make edits to the markdown file. Test it in R studio and commit if everything works

5. Go back to console in your bigdata folder

6. Issue the following command 

`git commit -am "added changes to markdown file"`

The text inside the quotation marks can be changed. Or click in `commit to carlos` from the github desktop. Instead of carlos it should say the name of your branch, otherwise you need to switch to your branch before commiting. NEVER COMMIT TO MASTER. 

7. Issue the following command

`git push origin carlos` 

Intead of carlos use your own name. Or in desktop fter you make a commit, on the top it should be an arrow and next to it should say push.

8. Now you can go to https://github.com/caariasr/bigdata.git and make a pull request.

## Getting the most recent version of the file

### When you already made changes

If you have changes to the .Rmd file but you want to have the most recent verion of the file (Let's you started working an hour ago but 5 minutes there was a pull request approved and you want that version)
This are the steps:

1. Commit your changes issuing 
`git commit -am "Some text"`

2. Issue the following command to get all commits from other people BEHIND your commits
`git pull --rebase origin master`

3. Now you have the most updated version + your local changes, you can either continue working or push your work for pull request.


