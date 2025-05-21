class AccessRoot
end

class Access < AccessBase
  define_access :view
  define_access :edit
  define_access :delete
  define_access :index
  define_access :access, [:view, :edit]
  define_access :manage, [:view, :edit, :delete, :index]

  allow :view, Root, :support
  allow :manage, Root, :admin

  allow :index, Person, :admin
  allow :index, Student, :admin

  allow :access,
        Student,
        [:administration, :registrar, :student]
  allow :index,
        Student,
        [:administration, :registrar]

  allow :edit,
        Person,
        :self do
    deny :edit,
         :ssn,
         :self
  end

end
