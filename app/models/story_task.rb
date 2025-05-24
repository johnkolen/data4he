class StoryTask < ApplicationRecord
  has_many :story_notes,
           inverse_of: :story_task,
           dependent: :destroy

  accepts_nested_attributes_for :story_notes,
                                update_only: true,
                                allow_destroy: true

  scope :todo , ->{where(status_id: StatusToDo)}
  scope :active , ->{where(status_id: StatusActive)}
  scope :blocked , ->{where(status_id: StatusBlocked)}
  scope :finished , ->{where(status_id: StatusFinished)}

  include MetaAttributes

  # used to add nested attributes
  def add_builds!
    story_notes.build
  end

  def status_label
    "Status"
  end

  STATUSES = {
    0 => "None",
    100 => "To Do",
    200 => "Active",
    300 => "Blocked",
    800 => "Finished",
    900 => "Backlog",
  }

  STATUSES.each do |id, label|
    define_method "#{label.parameterize(separator: '_')}?" do
      status_id == id
    end
    const_set "Status#{label.gsub(' ', '')}", id
  end

  def self.status_sym status_id
    STATUSES[status_id].parameterize(separator: '_').to_sym
  end

  def status_sym
    STATUSES[status_id].parameterize(separator: '_').to_sym
  end

  def self.status_str status_id
    STATUSES[status_id]
  end

  def status_str
    STATUSES[status_id]
  end

  def status_options
    STATUSES.map{|k,v| [v,k]}
  end

  def story_notes_label
    "Notes"
  end
end
