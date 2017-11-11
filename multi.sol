pragma solidity ^0.4.0;
import "./mortal.sol";
contract multi is mortal {
    event rFund(address from,uint amount);
    event prop_receive(address frm,address to,uint amount,string reason);
    mapping(uint=>proposal) myprop;
    struct proposal{
        address frm;
        address to;
        string res;
        uint amt;
        bool sent;
    }
    uint prop_count;
    function send_money(address _to,uint amt,string reason) returns (uint) {
        if(owner==msg.sender) {
            bool sent=_to.send(amt);
            if(!sent) {
                throw;
            }
        }
        else {
            prop_count++;
            myprop[prop_count]=proposal(msg.sender,_to,reason,amt,false);
            prop_receive(msg.sender,_to,amt,reason);
            return prop_count;
        }
    }
    function confirm(uint id) onlyowner returns (bool) {
        proposal obj=myprop[id];
        if(obj.frm!=address(0)) {
            if(obj.sent!=true) {
            obj.sent=true;
            if(obj.to.send(obj.amt)) {
                return true;
            }
            
                obj.sent=false;
                return false;
            
            }
        }
    }
    function() payable {
        if(msg.value>0) {
            rFund(msg.sender,msg.value);
        }
    }
}