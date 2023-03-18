// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract TaskContract {
    event AddTask(address receipient, uint taskId);
    event DeleteTask(uint taskId, bool isDeleted);
    
    struct Task {
        uint id;
        string taskText;
        bool isDeleted;
    }

    Task[] private tasks;
    mapping(uint => address) taskToOwner;

    function addTask(string memory taskText, bool isDeleted) external {
        uint taskId = tasks.length;
        tasks.push(Task(taskId, taskText, isDeleted));
        taskToOwner[taskId] = msg.sender;
        emit AddTask((msg.sender), taskId);
    }

    function deleteTask(uint taskId, bool isDeleted) external {
        if (taskToOwner[taskId] == msg.sender) {
            tasks[taskId].isDeleted = true;
        }
        emit DeleteTask(taskId, isDeleted);
    }

    function getMyTasks() external view returns(Task[] memory) {
        //create temporary array that is going to display all our tasks
        Task[] memory temporary = new Task[](tasks.length);
        uint counter = 0;

        for (uint i = 0; i < tasks.length; i++) {
            if (taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }
        //remove empty string from temporary ie tasks that have been deleted
        Task[] memory result = new Task[](counter);
        for (uint i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }
}
