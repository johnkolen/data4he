#  Start Here

##  Setup Ruby version contol

Use [rvm](https://rvi.io) to install Ruby 3.3.3

First, get the GPG keys for the download

    gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

Install RVM

    \curl -sSL https://get.rvm.io | bash -s stable

Install Ruby 3.3.3

    rvm install 3.3.3

RVM uses gem sets to manage gems for a project. You will need to create a gem set called data4he

    rvm gemset create data4he

## Github Preliminaries

Set up a [github](https://github.com} account.

It will be best to setup [ssh access](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

## Clone the Repository

Find a nice directory on your work machine and then clone the repository

    git clone git@github.com:johnkolen/data4he.git

## Setup Markdown viewer/editor

If you are editing the documentation files, it will be useful to have a viewer.

>     sudo apt install retext