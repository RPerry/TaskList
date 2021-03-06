require "test_helper"

describe TasksController do
  # Note to students:  Your Task model **may** be different and
  #   you may need to modify this.
  let (:task) {
    Task.create title: "sample task", content: "this is an example for a test",
                completiondate: false
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do

      # Arrange
      # Note to students:  Your Task model **may** be different and
      #   you may need to modify this.
      task_hash = {
        task: {
          title: "new task",
          content: "new task description",
          completiondate: "false",
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(title: task_hash[:task][:title])
      expect(new_task.content).must_equal task_hash[:task][:content]
      expect(new_task.completiondate).must_equal task_hash[:task][:completiondate]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do 
    it "can get the edit page for an existing task" do
      # Act
      task = Task.new
      task.title = "Get water"
      task.save

      get edit_task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path(999)

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      task = Task.new
      task.title = "Get water"
      task.save
      
      task_hash = {
        task: {
          title: "new task",
          content: "new task description",
          completiondate: "false",
        },
      }

      # Act-Assert
      expect {
        patch task_path(task.id), params: task_hash
      }.must_change "Task.count", 0

      expect(task.title).must_equal "Get water"
      #Repulling from database - updating the title variable
      task.reload
      expect(task.title).must_equal task_hash[:task][:title]
      expect(task.content).must_equal task_hash[:task][:content]
      expect(task.completiondate).must_equal task_hash[:task][:completiondate]

      must_respond_with :redirect
      must_redirect_to task_path(task.id)
    end

    it "will redirect to the root page if given an invalid id" do
        patch task_path(999)
        must_respond_with :redirect
        must_redirect_to tasks_path
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    # Your tests go here
    it "removes the task from the database" do
      task = Task.create(title: "Task Test")
      
      expect {
        delete task_path(task)
      }.must_change "Task.count", -1

      must_respond_with :redirect
      must_redirect_to tasks_path

      after_task = Task.find_by(id: task.id)
      expect(after_task).must_be_nil
    end

    it "returns a 404 if the book does not exist" do
      task_id = 999

      expect(Task.find_by(id: task_id)).must_be_nil

      expect {
        delete task_path(task_id)
      }.wont_change "Task.count"

      must_respond_with :not_found
    end
  end

  # Complete for Wave 4
  describe "completed" do
    it "Can change from Mark complete to unmark complete" do
      task = Task.create(title: "test task", completiondate: nil)

      completed = {
        task: {
          completed: true,
        },
      }

      expect(task.completed).must_equal false

      expect {
        patch completed_task_path(task.id), params: completed
      }.must_change "Task.count", 0

      task.reload

      expect(task.completed).must_equal true

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
end