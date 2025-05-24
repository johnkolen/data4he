# New Model

Here are the steps for creating a new model with all the CRUD operations

## Generate the rails scaffold

    rails generate scaffold story_task title:string description:string priority:integer status_id:integer

## Edit the migration file to add extra attribute constraints

    edit db/migrate/*create_story_tasks.rb

and add defaults, foriegn keys, etc.

    create_table :story_tasks do |t|
      t.string :title, default: "Title"
      t.string :description, default: "Description"
      t.integer :priority, default: 0
      t.integer :status_id, default: 0

      t.timestamps
    end

## Create the tables by running the migration

    rake db:migrate

## Add the Object View view files

    rails generate obj_view_views story_task

This generator overwrites view files created with the scaffold generator. Just
press enter on the overwrite prompt.

## Fixup the Controller for Object View

    edit app/controllers/story_tasks_controller.rb

For all

    @story_tasks = something

Change to

    @objects = @story_tasks = something

Likewise,

    @story_task = something

Change to

    @object = @story_task = something

Add a class method story_task_params by moving the array after story_task: in
story_note_params at the end of the file. This definition should be public, put it before the private directive.

    def self.story_task_params
      [ :title, :description, :priority, :status_id ]
    end

Change the following method

    def story_task_params
      params.expect(story_task: self.class.story_task_params)
    end

Near the top of the controller add
    before_action :set_klass

## Fixup the Model

    edit app/models/story_task.rb

Add the Meta Attributes concern

    include MetaAttributes
