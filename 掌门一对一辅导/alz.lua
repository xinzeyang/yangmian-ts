
require("TSLib")
require("tsp")



function get(url)
	local sz = require("sz")
	local http = require("szocket.http")
	local res, code = http.request(url);
	if code == 200 then
		local json = sz.json
		if res ~= nil then
			return json.decode(res)
		end
	end
end


function _vCode_ym(User,Pass,PID) --易码平台
	local User = 'shuaishuai1983'
	local Pass = 'shuai888@'
	local PID = '723'
    local token,uid,number = "",""
    return {
        login=(function() 
            local RetStr
			for i=1,5,1 do
				toast("获取token\n"..i.."次共5次")
                mSleep(1500)
                RetStr = httpGet('http://i.fxhyd.cn:8080/UserInterface.aspx?action=login&username='..User..'&password='..Pass.."&author=yangmian")
				if RetStr then
					nLog(RetStr)
					RetStr = strSplit(RetStr,"|")
					if RetStr[1] == 'success' then
						token = RetStr[2]
						log('token='..token,true)
						break
					else
						toast("fail--"..RetStr[1])
						mSleep(1500)
					end
				end
			end
			return RetStr;
        end),
	    getPhone=(function()
            local RetStr=""
			RetStr = httpGet("http://i.fxhyd.cn:8080/UserInterface.aspx?action=getmobile&excludeno=165&itemid="..PID.."&token="..token.."&timestamp="..os.time())
			if RetStr ~= "" and  RetStr ~= nil then
				log(RetStr,true)
				RetStr = strSplit(RetStr,"|")
			end
			if RetStr[1]== 'success' then
				number = RetStr[2]
				log(number,true)
				return number
			else
				log(RetStr[1],true)
			end
        end),
	    getMessage=(function()
			local Msg
            for i=1,25,1 do
                mSleep(3000)
                RetStr = httpGet("http://i.fxhyd.cn:8080/UserInterface.aspx?action=getsms&token="..token.."&mobile="..number.."&itemid="..PID.."&release=1&timestamp="..os.time())
				if RetStr then
					local arr = strSplit(RetStr,"|") 
					if arr[1] == 'success' then 
						Msg = arr[2]
						log(Msg,true)
						local i,j = string.find(Msg,"%d+")
						Msg = string.sub(Msg,i,j)
					end
					if type(tonumber(Msg))== "number" then return Msg end
				end
                toast(tostring(RetStr).."\n"..i.."次共25次")
            end
            return ""
        end),
        addBlack=(function()
            return httpGet("http://api.ndd001.com/do.php?action=addBlacklist&token="..token.."&phone="..number.."&sid="..PID)
        end),
    }
end


--来信平台
function _vCode_lx() --来信
	local User = 'yangmian1'
	local Pass = 'yangmian121'
	local PID = '1624'
    local token,uid,number = "",""
    return {
	    login=(function() 
            local RetStr
			for i=1,5,1 do
				toast("获取token\n"..i.."次共5次")
                mSleep(1500)
                RetStr = httpGet('http://api.smskkk.com/api/do.php?action=loginIn&name='..User..'&password='..Pass)
				if RetStr then
					RetStr = strSplit(RetStr,"|")
					if RetStr[1] == 1 or RetStr[1] == '1' then
						token = RetStr[2]
						log('token='..token,true)
						break
					end
				end
			end
			return RetStr;
        end), 
		getPhone=(function()
            local RetStr=""
			RetStr = httpGet("http://api.smskkk.com/api/do.php?action=getPhone&sid="..PID.."&token="..token..'&vno=0')
			if RetStr ~= "" and  RetStr ~= nil then
				RetStr = strSplit(RetStr,"|")
			end
			if RetStr[1] == 1 or RetStr[1]== '1' then
				number = RetStr[2]
				log(number,true)
				return number
			end
        end),
	    getMessage=(function()
			local Msg
            for i=1,25,1 do
                mSleep(3000)
                RetStr = httpGet("http://api.smskkk.com/api/do.php?action=getMessage&sid="..PID.."&token="..token.."&phone="..number)
				if RetStr then
					local arr = strSplit(RetStr,"|") 
					if arr[1] == '1' then 
						Msg = arr[2]
						local i,j = string.find(Msg,"%d+")
						Msg = string.sub(Msg,i,j)
					end
					if type(tonumber(Msg))== "number" then return Msg end
				end
                toast(tostring(RetStr).."\n"..i.."次共25次")
            end
            return ""
        end),
        addBlack=(function()
            return httpGet("http://huoyun888.cn/api/do.php?action=getMessage&sid="..PID.."&token="..token.."&phone="..number)
        end),
    }
end



--165
function _vCode_dm()
	local User = 'shuaishuai'
	local Pass = 'shuai888'
	local PID = '3215'
    local token,uid,number = "",""
	local api_url = "http://api.yyyzmpt.com/index.php/"
    return {
	    login=(function() 
            local RetStr
			for i=1,5,1 do
				toast("获取token\n"..i.."次共5次")
                mSleep(1500)
				local urls = api_url..'reg/login?username='..User..'&password='..Pass
				nLog(urls)
                RetStr = get(urls)
				if RetStr then
					if RetStr['errno'] == 0 then
						token = RetStr['ret']['token']
--						log('token='..token,true)
						nLog('token='..token)
						break
					else
						toast(RetStr.errmsg)
						mSleep(2000)
					end
				end
			end
			return RetStr;
        end), 
		getPhone=(function()
            local RetStr=""
			local urls = api_url..'clients/online/setWork?token='..token..'&t=1&pid='..PID
			nLog(urls)
			RetStr = get(urls)
			if RetStr then
				if RetStr['errno'] == 0 then
					number = RetStr['ret']['number']
					toast('number='..number)
					nLog('number='..number)
					return number
				else
					toast(RetStr.errmsg)
					mSleep(2000)
				end
			end

        end),
	    getMessage=(function()
			local Msg
            for i=1,25,1 do
                mSleep(3000)
				local urls = api_url..'clients/sms/getSms?type=1&token='..token..'&project='..PID..'&number='..number
				nLog(urls)
				RetStr = get(urls)
				if RetStr then
					if RetStr['errno'] == 0 then
						Msg = RetStr['ret']['tst']
	--					log('token='..token,true)
						nLog('Msg='..Msg)
						local i,j = string.find(Msg,"%d+")
						Msg = string.sub(Msg,i,j)
						return Msg
					else
						toast(RetStr.errmsg)
						mSleep(2000)
					end
				end
                toast(i.."次共25次")
            end
            return ""
        end),
        addBlack=(function()
            return httpGet( api_url.."?action=getMessage&sid="..PID.."&token="..token.."&phone="..number)
        end),
    }
end

--code = _vCode_hy()
--code.login()
--delay(3)
--log(
--code.getPhone() )




