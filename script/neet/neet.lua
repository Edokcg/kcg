--部分同调相关--
local SynchroMaterial=Card.IsCanBeSynchroMaterial
function Card.IsCanBeSynchroMaterial(c,sc,tc)
	if not c:HasLevel() and sc and (sc.synchrouserank or sc.synchrouselink) then
		local effs={c:GetCardEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)}
		for _,eff in ipairs(effs) do
			local f=eff:GetValue()
			if f and not f(eff,sc) then
				return false
			end
		end
		return true
	end
	if not c:HasLevel() and c:IsHasEffect(1196) and sc then 
		for _,eff in ipairs(effs) do
			local f=eff:GetValue()
			if f and not f(eff,sc) then
				return false
			end
		end
		return true
	end
	if not sc then
		return SynchroMaterial(c)
	else
		return SynchroMaterial(c,sc,tc)
	end
end
local SynchroLevel=Card.GetSynchroLevel
function Card.GetSynchroLevel(c,sc)
	if sc.synchrouserank and not c:HasLevel() and c:IsType(TYPE_XYZ) then
		return c:GetRank()
	elseif sc.synchrouselink and not c:HasLevel() and c:IsType(TYPE_LINK) then
		return c:GetLink()
	end
	if not c:HasLevel() and c:IsHasEffect(1196) then return c:GetLink() end
	return SynchroLevel(c,sc)
end
function Synchro.CheckP43(tsg,ntsg,sg,lv,sc,tp)
	if sg:IsExists(Synchro.CheckHand,1,nil,sg) then return false end
	local lvchk=false
	if sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM) then
		local g=sg:Filter(Card.IsHasEffect,nil,EFFECT_SYNCHRO_MATERIAL_CUSTOM)
		for tc in aux.Next(g) do
			local teg={tc:GetCardEffect(EFFECT_SYNCHRO_MATERIAL_CUSTOM)}
			for _,te in ipairs(teg) do
				local op=te:GetOperation()
				local ok,tlvchk=op(te,tg,ntg,sg,lv,sc,tp)
				if not ok then return false end
				lvchk=lvchk or tlvchk
			end
		end
	end
	return (not Synchro.CheckAdditional or Synchro.CheckAdditional(tp,sg,sc))
	and (lvchk or sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sc) or (sc.lvchk_ex and sc.lvchk_ex(tsg,ntsg,sg,lv,sc,tp)) or Synchro.vylonchk(tsg,ntsg,sg,lv,sc,tp))
	and ((sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0)
		or (not sc:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,sg,tp)>0))
end
function Synchro.vylonchk(tsg,ntsg,sg,lv,sc,tp)
	if not sc:IsSetCard(0x30) then return false end
	return sg:IsExists(Card.IsHasEffect,1,nil,1196)
end
--部分同调相关--
----
--返回卡片[以tp来看 tp=c:GetControler()]属于第几列
function Card.GetColumns(c,tp)
	if tp==nil then tp=c:GetControler() end
	local seq=c:GetSequence()

	if c:IsLocation(LOCATION_MZONE) and seq>=5 then
		if seq==5 then
			return c:IsControler(tp) and 1 or 3
		elseif seq==6 then
			return c:IsControler(tp) and 3 or 1
		end
	elseif c:IsLocation(LOCATION_ONFIELD) and seq<=4 then
		if c:IsControler(tp) then 
			return seq
		else
			return math.abs(4-seq)
		end
	--场地和大师3的灵摆区能够进行列比较吗（？ 
	--左右灵摆区返回 -1和5会不会好一点
	elseif c:IsLocation(LOCATION_FZONE) then
		return 5
	elseif c:IsLocation(LOCATION_PZONE) and seq>=6 then
		if c:IsControler(tp) then
			return seq
		else
			return seq==6 and 7 or 6
		end   
	end
	return nil
end
----
----进入土俵！(1789)----
function Pendulum.Filter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	local chk=false
	if c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPIRIT) and Duel.IsPlayerAffectedByEffect(tp,1789) then chk=true end
	-- 暂时不想做兼容
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,chk,false)
		and not c:IsForbidden()
end
----进入土俵！(1789)----
----装弹枪管刑罚龙(1860)----
if not aux.PendulumProcedure then
	aux.PendulumProcedure = {}
	PendulumNeet = aux.PendulumProcedure
end
if not PendulumNeet then
	PendulumNeet = aux.PendulumProcedure
end
--add procedure to PendulumNeet monster, also allows registeration of activation effect
PendulumNeet.AddProcedure = aux.FunctionWithNamedArgs(
function(c,reg,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(aux.Stringid(1860,0))
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(PendulumNeet.Condition())
	e1:SetOperation(PendulumNeet.Operation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
end,"handler","register","desc")
function PendulumNeet.Filter(c,e,tp,lscale,rscale,lvchk,revolver)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	local chk=false
	if c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPIRIT) and Duel.IsPlayerAffectedByEffect(tp,1789) then chk=true end
	--虽然枪管没有灵魂怪兽
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423) or (revolver and c:IsSetCard({0x10f,0x102}) and c:IsLevelBelow(9))) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,chk,false)
		and not c:IsForbidden()
end
function PendulumNeet.Condition()
	return  function(e,c,inchain,re,rp)
				if c==nil then return true end
				local tp=c:GetControler()
				local revolver=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.CheckPendulumZones(tp) and c:IsOriginalCodeRule(1860)
				if revolver==false then
					local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
					if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end
					local lscale=c:GetLeftScale()
					local rscale=rpz:GetRightScale()
					local loc=0
					if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
					if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
					if loc==0 then return false end
					local g=nil
					if og then
						g=og:Filter(Card.IsLocation,nil,loc)
					else
						g=Duel.GetFieldGroup(tp,loc,0)
					end
					return g:IsExists(Pendulum.Filter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				elseif revolver==true then
					if not inchain and Duel.GetFlagEffect(tp,10000000)>0 then return false end
					local loc=0
					if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
					if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
					if loc==0 then return false end
					local g=nil
					if og then
						g=og:Filter(Card.IsLocation,nil,loc)
					else
						g=Duel.GetFieldGroup(tp,loc,0)
					end

					return g:IsExists(PendulumNeet.Filter,1,nil,e,tp,0,0,false,revolver)
				end
			end
end
function PendulumNeet.Operation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
				local revolver=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.CheckPendulumZones(tp) and c:IsOriginalCodeRule(1860)
				if revolver==false then
					local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
					local lscale=c:GetLeftScale()
					local rscale=rpz:GetRightScale()
					local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
					local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
					local ft=Duel.GetUsableMZoneCount(tp)
					if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
						if ft1>0 then ft1=1 end
						if ft2>0 then ft2=1 end
						ft=1
					end
					local loc=0
					if ft1>0 then loc=loc+LOCATION_HAND end
					if ft2>0 then loc=loc+LOCATION_EXTRA end
					local tg=nil
					if og then
						tg=og:Filter(Card.IsLocation,nil,loc):Match(Pendulum.Filter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
					else
						tg=Duel.GetMatchingGroup(Pendulum.Filter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
					end
					ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
					ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
					ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
					while true do
						local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
						local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
						local ct=ft
						if ct1>ft1 then ct=math.min(ct,ft1) end
						if ct2>ft2 then ct=math.min(ct,ft2) end
						local loc=0
						if ft1>0 then loc=loc+LOCATION_HAND end
						if ft2>0 then loc=loc+LOCATION_EXTRA end
						local g=tg:Filter(Card.IsLocation,sg,loc)
						if #g==0 or ft==0 then break end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
						if not tc then break end
						if sg:IsContains(tc) then
							sg:RemoveCard(tc)
							if tc:IsLocation(LOCATION_HAND) then
								ft1=ft1+1
							else
								ft2=ft2+1
							end
							ft=ft+1
						else
							sg:AddCard(tc)
							if c:IsHasEffect(511007000)~=nil or rpz:IsHasEffect(511007000)~=nil then
								if not Pendulum.Filter(tc,e,tp,lscale,rscale) then
									local pg=sg:Filter(aux.TRUE,tc)
									local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
									sg:Sub(pg)
									ft1=ft1+ct3
									ft2=ft2+ct4
									ft=ft+ct0
								else
									local pg=sg:Filter(aux.NOT(Pendulum.Filter),nil,e,tp,lscale,rscale)
									sg:Sub(pg)
									if #pg>0 then
										if pg:GetFirst():IsLocation(LOCATION_HAND) then
											ft1=ft1+1
										else
											ft2=ft2+1
										end
										ft=ft+1
									end
								end
							end
							if tc:IsLocation(LOCATION_HAND) then
								ft1=ft1-1
							else
								ft2=ft2-1
							end
							ft=ft-1
						end
					end
					if #sg>0 then
						if not inchain then
							Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
						end
						Duel.HintSelection(Group.FromCards(c),true)
						Duel.HintSelection(Group.FromCards(rpz),true)
					end
				elseif revolver==true then
					local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
					local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
					local ft=Duel.GetUsableMZoneCount(tp)
					if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
						if ft1>0 then ft1=1 end
						if ft2>0 then ft2=1 end
						ft=1
					end
					local loc=0
					if ft1>0 then loc=loc+LOCATION_HAND end
					if ft2>0 then loc=loc+LOCATION_EXTRA end
					local tg=nil
					if og then
						tg=og:Filter(Card.IsLocation,nil,loc):Match(PendulumNeet.Filter,nil,e,tp,9,9,false,revolver)
					else
						tg=Duel.GetMatchingGroup(PendulumNeet.Filter,tp,loc,0,nil,e,tp,9,9,false,revolver)
					end
					ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
					ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
					ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
					while true do
						local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
						local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
						local ct=ft
						if ct1>ft1 then ct=math.min(ct,ft1) end
						if ct2>ft2 then ct=math.min(ct,ft2) end
						local loc=0
						if ft1>0 then loc=loc+LOCATION_HAND end
						if ft2>0 then loc=loc+LOCATION_EXTRA end
						local g=tg:Filter(Card.IsLocation,sg,loc)
						if #g==0 or ft==0 then break end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
						if not tc then break end
						if sg:IsContains(tc) then
							sg:RemoveCard(tc)
							if tc:IsLocation(LOCATION_HAND) then
								ft1=ft1+1
							else
								ft2=ft2+1
							end
							ft=ft+1
						else
							sg:AddCard(tc)
							if c:IsHasEffect(511007000)~=nil then
								if not PendulumNeet.Filter(tc,e,tp,9,9,revolver) then
									local pg=sg:Filter(aux.TRUE,tc)
									local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
									sg:Sub(pg)
									ft1=ft1+ct3
									ft2=ft2+ct4
									ft=ft+ct0
								else
									local pg=sg:Filter(aux.NOT(PendulumNeet.Filter),nil,e,tp,9,9,revolver)
									sg:Sub(pg)
									if #pg>0 then
										if pg:GetFirst():IsLocation(LOCATION_HAND) then
											ft1=ft1+1
										else
											ft2=ft2+1
										end
										ft=ft+1
									end
								end
							end
							if tc:IsLocation(LOCATION_HAND) then
								ft1=ft1-1
							else
								ft2=ft2-1
							end
							ft=ft-1
						end
					end
					if #sg>0 then
						if not inchain then
							Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
						end
						Duel.HintSelection(Group.FromCards(c),true)
						Duel.SetLP(tp,Duel.GetLP(tp)-#sg*500)
						--Duel.HintSelection(Group.FromCards(rpz),true)
					end
				end
			end
end
----装弹枪管刑罚龙(1860)----
-----
--返回卡片c的等级 阶级 连接值中的一个
function Card.GetLevelRankLink(c)
	if c:HasLevel() then
		return c:GetLevel()
	elseif c:HasRank() then 
		return c:GetRank()
	elseif c:HasLink() then
		return c:GetLink()
	end
	return 0
end
function Card.HasLevelRankLink(c)
	if not c:HasLevel() and not c:HasRank() and not c:HasLink() then return false end
	return true
end
----