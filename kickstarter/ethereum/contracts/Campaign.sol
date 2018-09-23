pragma solidity ^0.4.17;

contract CampaignFactory{
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public{
        deployedCampaigns.push(new Campaign(minimum, msg.sender));
    }

    function getDeployedCampaigns() public view returns(address []){
        return deployedCampaigns;
    }
}

contract Campaign{
    address public manager;
    uint public minimumContribution;
    mapping(address=>bool)public approvers;
    Request[] public requests;
    uint public approversCount;


    struct Request{
        string description;
        uint value;
        address recipent;
        bool complete;
        mapping(address=>bool) approvals;
        uint approvalCount;
    }

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum, address creator) public{
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable{
        require(msg.value>minimumContribution);
        approvers[msg.sender] = true ;
        approversCount++;
    }

    function createRequest(string description, uint value, address recipent) public restricted{
        Request memory newRequest = Request({
            description:description,
            value:value,
            recipent:recipent,
            complete:false,
            approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint index) public{
        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        request.approvalCount++;
        request.approvals[msg.sender] = true;
    }

    function finalizeRequest(uint index) public payable restricted{
        Request storage request = requests[index];
        require(request.approvalCount>(approversCount/2));
        require(!request.complete);

        request.recipent.transfer(request.value);
        request.complete=true;


    }
}
