class AccessRoot
end

class Access < AccessBase
  define_access :create
  define_access :view
  define_access :edit
  define_access :delete
  define_access :index
  define_access :access, [ :view, :edit ]
  define_access :access_all, [ :view, :edit, :index ]
  define_access :manage, [ :create, :view, :edit, :delete, :index ]

  allow :view, Root, :support
  allow :manage, Root, :admin

  def self.person_access_self
    allow :edit,
          Person,
          :self do
      deny :edit,
           :ssn,
           :self
    end
  end

  person_access_self

  allow :access,
        Student,
        :self do
    person_access_self
  end

  allow :access_all,
        Student,
        [ :administration, :registrar ]


  allow :edit,
        User,
        :self do
    person_access_self
  end
end
