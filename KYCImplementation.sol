pragma solidity ^0.4.21;



contract KYCImplementation {
    
    event recoverdSignerEvent(address signer, address whitelistedAddress);
    address public owner = address(0x20D73ef8eBF344b2930d242DA5DeC79d9dD9A92a);
    
    function isKYCApproved(bytes _dataFrame, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (bool){
        
        address whitelistedAddress =  sliceAddress(_dataFrame,0);
        bytes32 hash = keccak256(_dataFrame);
        address recoverdSigner = ecrecover(hash,_v,_r,_s); 
        
        require(whitelistedAddress == msg.sender);
        require(recoverdSigner == owner);
        return true;
    }
    
    modifier onlyWhitelisted(bytes dataframe, uint8 v, bytes32 r, bytes32 s) {
        require( isKYCApproved(dataframe,v,r,s)  ); 
        _;
    }
    
    function buyTokens(bytes dataframe, uint8 v, bytes32 r, bytes32 s) onlyWhitelisted(dataframe,v,r,s) public view returns (bool) {
        return true;
    }
    
    function sliceAddress(bytes b, uint offset) pure private returns (address) {
        bytes32 out;
        for (uint i = 0; i < 20; i++) {
          out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
        }
        return address(uint(out));
    }
}
