// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

pragma experimental ABIEncoderV2;

contract ShortContent{
		// userid 对应一个集合， userid => title+topic+content
	mapping(string => string[]) userArticles;
	// userid + topic 对应一个集合 userid + topic => title + topic + content
	mapping(string => string[]) utopicArticles;
	// userid + title 对应一篇文章 userid + title => title + topic + content
	mapping(string => string) utitleArticles;
	// 长度限制
	uint256 maxTopicLen;
	uint256 maxTitleLen;
	uint256 maxContentLen;
	constructor(){
    maxTopicLen = 36;
    maxTitleLen = 100;
    maxContentLen = 3000;
  }

  function storeShortContent(string memory userid, string memory title, string memory topic, string memory content) external returns (string memory message) {
  	// 长度检验
  	require(bytes(title).length < maxTitleLen, "this title is too long");
  	require(bytes(topic).length < maxTopicLen, "this topic is too long");
  	require(bytes(content).length < maxContentLen, "this content is too long");
  	// 添加映射
  	string memory result = string(abi.encodePacked(userid,"/",title,"/",topic,"/",content));
  	string memory utopic = string(abi.encodePacked(userid,topic));
  	string memory utitle = string(abi.encodePacked(userid,title));
  	userArticles[userid].push(result);
  	utopicArticles[utopic].push(result);
  	utitleArticles[utitle] = result;
  	return "store short content success";
  }

  function queryByUser(string memory userid) public view returns(string[] memory articles){
  	return userArticles[userid];
  }

  function queryByTopic(string memory userid, string memory topic) public view returns(string[] memory articles){
  	string memory utopic = string(abi.encodePacked(userid,topic));
  	return utopicArticles[utopic];
  }

  function queryByTitle(string memory userid, string memory title) public view returns(string memory articles){
  	string memory utitle = string(abi.encodePacked(userid,title));
  	return utitleArticles[utitle];
  }
}
