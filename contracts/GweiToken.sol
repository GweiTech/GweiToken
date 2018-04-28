pragma solidity ^0.4.19;


library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ERC20Basic {

    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    
    event Transfer(
        address indexed from, 
        address indexed to, 
        uint256 value
    );
}

contract BasicToken is ERC20Basic {

    address[] tokenOwners;
    using SafeMath for uint256;
    mapping(address => uint256) balances;
    uint256 totalSupply_;

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        
        if (!contains(tokenOwners, _to)) {
            tokenOwners.push(_to);
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function contains(address[] storage list, address addr) internal constant returns (bool) {
        for (uint i = 0; i < list.length; i++) {
            if (list[i] == addr) {
                return true;
            }
        }
        return false;
    }
}

contract GweiToken is BasicToken {
    
    string tokenName;
    string tokenSymbol;
    address owner;

    function GweiToken(
        address _owner,
        string _tokenName,
        string _tokenSymbol,
        uint _totalSupply
    ) public {
        tokenOwners.push(_owner);
        owner = _owner;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        require(_totalSupply >= 100000000 && _totalSupply <= 1000000000);
        totalSupply_ = uint256(_totalSupply * (10 ** decimals()));
        balances[owner] = totalSupply_;
        Transfer(0x0, owner, totalSupply_);
    }

    function name() public constant returns (string) {
        return tokenName;
    }

    function symbol() public constant returns (string) {
        return tokenSymbol;
    }

    function decimals() public pure returns (uint256) {
        return uint256(18);
    }

    function isToken() public pure returns (bool) {
        return true;
    }
    
    function getOwner() external constant returns (address) {
        return owner;
    }

    function getAllTokenOwners() external constant returns (address[] _owners, uint[] _values) {
        uint[] memory tokens = new uint[](tokenOwners.length);

        for (uint i = 0; i < tokenOwners.length; i++) {
            tokens[i] = balances[tokenOwners[i]];
        }

        return (
            tokenOwners, 
            tokens
        );
    }
}


