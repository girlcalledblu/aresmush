module AresMUSH
  class Game
    field :next_job_number, :type => Integer, :default => 1
  end
  
  class Character
    has_many :submitted_requests, :class_name => 'AresMUSH::Job', :inverse_of => :author
    has_many :assigned_jobs, :class_name => 'AresMUSH::Job', :inverse_of => :assigned_to
    
    has_many :job_replies
  end
  
  class Job
    include Mongoid::Document
    include Mongoid::Timestamps
        
    field :title, :type => String
    field :description, :type => String
    field :category, :type => String
    field :status, :type => String
    field :number, :type => Integer
    
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => :submitted_requests
    belongs_to :assigned_to, :class_name => "AresMUSH::Character", :inverse_of => :assigned_jobs

    has_many :job_replies, order: :created_at.asc, :dependent => :destroy
    
    def is_open?
      self.status != "DONE"
    end
  end
  
  class JobReply
    include Mongoid::Document
    include Mongoid::Timestamps
    
    belongs_to :job
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'job_replies'
    
    field :admin_only, :type => Boolean
    field :message, :type => String
  end
end