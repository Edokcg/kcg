--覇王龍ズァーク
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c,false)
	
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetDescription(1174)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCondition(s.LCondition(nil,2,8,s.matfilter))
	e01:SetTarget(s.LTarget(nil,2,8,s.matfilter))
	e01:SetOperation(s.LOperation(nil,2,8,s.matfilter))
	e01:SetValue(SUMMON_TYPE_LINK+SUMMON_TYPE_XYZ)
	c:RegisterEffect(e01)
	
	-- Level/Rank
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(EFFECT_LEVEL_RANK_LINK)
	-- c:RegisterEffect(e0)
	
	--spsummon condition
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetCode(EFFECT_SPSUMMON_CONDITION)
	e15:SetValue(aux.lnklimit)
	c:RegisterEffect(e15)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(13331639)
	c:RegisterEffect(e1)
	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.limval)
	c:RegisterEffect(e2)

	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(s.sppcon)
	e5:SetOperation(s.sppop)
	c:RegisterEffect(e5)
	--spsummon immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	
	--destroy all
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(13331639,1))
	e7:SetProperty(EFFECT_FLAG_DELAY)   
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)

	--immune
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e16:SetCode(EFFECT_IMMUNE_EFFECT)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e16:SetValue(s.efilter)
	c:RegisterEffect(e16)		
	
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	e22:SetCondition(s.indcon)   
	e22:SetValue(s.refilter)
	c:RegisterEffect(e22)	
	
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.indcon)   
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e19=e9:Clone()
	e19:SetCode(EFFECT_IMMUNE_EFFECT)
	e19:SetValue(s.imfilter) 
	c:RegisterEffect(e19)
	-- local e12=e9:Clone()
	-- e12:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	-- e12:SetValue(aux.AND(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_RITUAL),s.imfilter))
	-- c:RegisterEffect(e12)
		
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(13331639,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BATTLED)
	e10:SetCondition(s.spcon)
	e10:SetTarget(s.sptg)
	e10:SetOperation(s.spop)
	c:RegisterEffect(e10)
	
	--handes
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(48739166,0))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_HAND)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.hdcon)
	e11:SetOperation(s.hdop)
	c:RegisterEffect(e11)
	
	--pendulum
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(13331639,3))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_LEAVE_FIELD)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCondition(s.pencon)
	--e12:SetTarget(s.pentg)
	e12:SetOperation(s.penop)
	c:RegisterEffect(e12)

	--special summon
	-- local e13=Effect.CreateEffect(c)
	-- e13:SetType(EFFECT_TYPE_FIELD)
	-- e13:SetCode(EFFECT_SPSUMMON_PROC)
	-- e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e13:SetRange(LOCATION_EXTRA)
	-- e13:SetCondition(s.spcon)
	-- e13:SetOperation(s.spop2)
	-- c:RegisterEffect(e13)

	--SpecialSummon
	local e14=Effect.CreateEffect(c)
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetDescription(aux.Stringid(id,0))
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetCountLimit(1)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCost(s.ctcost)
	e14:SetTarget(s.cttg)
	e14:SetOperation(s.ctop)
	c:RegisterEffect(e14,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_series={0x20f8}
s.listed_names={48}

function s.matfilter(g,lc,sumtype,tp)
	return g:FilterCount(Card.IsType,nil,TYPE_FUSION,lc)>0 and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO,lc)>0 and g:FilterCount(Card.IsType,nil,TYPE_XYZ,lc)>0 and g:FilterCount(Card.IsType,nil,TYPE_PENDULUM,lc)>0 and g:FilterCount(Card.IsType,nil,TYPE_RITUAL,lc)>0
end

function s.LConditionFilter(c,f,lc,tp)
	return c:IsCanBeLinkMaterial(lc,tp) and c:IsCanBeXyzMaterial(lc) and (not f or f(c,lc,SUMMON_TYPE_XYZ|SUMMON_TYPE_LINK|MATERIAL_LINK,tp))
end
function s.GetLinkCount(c)
	if c:IsLinkMonster() and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		local typecount = 0
		if c:IsType(TYPE_FUSION) then typecount = typecount + 1 end
		if c:IsType(TYPE_SYNCHRO) then typecount = typecount + 1 end
		if c:IsType(TYPE_XYZ) then typecount = typecount + 1 end
		if c:IsType(TYPE_PENDULUM) then typecount = typecount + 1 end
		if c:IsType(TYPE_RITUAL) then typecount = typecount + 1 end
		if not c:IsType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO+TYPE_PENDULUM+TYPE_RITUAL) then typecount = 1 end
		return typecount
	end
end
function s.CheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	if #sg>maxc then return false end
	filt=filt or {}
	sg:AddCard(c)
	for _,filt in ipairs(filt) do
		if not filt[2](c,filt[3],tp,sg,mg,lc,filt[1],1) then
			sg:RemoveCard(c)
			return false
		end
	end
	if not og:IsContains(c) then
		res=aux.CheckValidExtra(c,tp,sg,mg,lc,emt,filt)
		if not res then
			sg:RemoveCard(c)
			return false
		end
	end
	local res=s.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(s.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function s.CheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	if #sg>maxc then return false end
	sg:AddCard(c)
	for _,filt in ipairs(filt) do
		if not filt[2](c,filt[3],tp,sg,mg,lc,filt[1],1) then
			sg:RemoveCard(c)
			return false
		end
	end
	if not og:IsContains(c) then
		res=aux.CheckValidExtra(c,tp,sg,mg,lc,emt,filt)
		if not res then
			sg:RemoveCard(c)
			return false
		end
	end
	if #(sg2-sg)==0 then
		if secondg and #secondg>0 then
			local res=secondg:IsExists(s.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=s.CheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=s.CheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function s.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return #sg>=minc and sg:CheckWithSumEqual(s.GetLinkCount,lc:GetLink(),#sg,#sg)
		and (not specialchk or specialchk(sg,lc,SUMMON_TYPE_XYZ|SUMMON_TYPE_LINK|MATERIAL_LINK,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function s.LCondition(f,minc,maxc,specialchk)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				local mg=g:Filter(s.LConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_XYZ+REASON_LINK)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(s.LConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK)
				tg=tg:Filter(s.LConditionFilter,nil,f,c,tp)
				local res=(mg+tg):Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(s.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=(mg+tg):IsExists(s.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function s.LTarget(f,minc,maxc,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(s.LConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LINK)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK)
				tg=tg:Filter(s.LConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<max do
					local filters={}
					if #sg>0 then
						s.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=(mg+tg):Filter(s.CheckRecursive,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and s.CheckGoal(tp,sg,c,min,f,specialchk,filters)
					cancel=not og and Duel.IsSummonCancelable() and #sg==0
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,1,1)
					if not tc then break end
					if #mustg==0 or not mustg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if #sg>0 then
					local filters={}
					s.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					sg:KeepAlive()
					local reteff=Effect.GlobalEffect()
					reteff:SetTarget(function()return sg,filters,emt end)
					e:SetLabelObject(reteff)
					return true
				else 
					aux.DeleteExtraMaterialGroups(emt)
					return false
				end
			end
end
function s.LOperation(f,minc,maxc,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
				local g,filt,emt=e:GetLabelObject():GetTarget()()
				e:GetLabelObject():Reset()
				for _,ex in ipairs(filt) do
					if ex[3]:GetValue() then
						ex[3]:GetValue()(1,SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK,ex[3],ex[1]&g,c,tp)
					end
				end
				c:SetMaterial(g)
				for tc in aux.Next(g) do
					local mg = tc:GetOverlayGroup()
					if mg:GetCount()>0 then
						Duel.Overlay(c, mg) 
					end
				end
				--Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				Duel.Overlay(c, g)
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end

function s.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_RITUAL+TYPE_LINK)
end

function s.sppfilter(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsSetCard(0xf8)
end
function s.sppcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and e:GetHandler():IsFaceup()
		and Duel.IsExistingMatchingCard(s.sppfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
function s.sppop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.sppfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g<1 then return end
	Duel.SendtoGrave(g,REASON_COST)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return g:GetCount()>0 end
	local tc=g:GetFirst()
	local tatk=0
	while tc do
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	tatk=tatk+atk
	tc=g:GetNext() end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tatk)	
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local g2=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		local tc=g2:GetFirst()
		local tatk=0
		while tc do
		local atk=tc:GetPreviousAttackOnField()
		if atk<0 then atk=0 end
		tatk=tatk+atk
		tc=g2:GetNext() end 
		Duel.Damage(1-tp,tatk,REASON_EFFECT)
	end
end

function s.efilter(e,te)
	--local tc=te:GetHandler()
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
	--and (te:IsActiveType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO+TYPE_PENDULUM+TYPE_RITUAL+TYPE_LINK))
end

function s.ndcfilter(c)
	return c:IsFaceup() 
	and (c:IsType(TYPE_XYZ+TYPE_FUSION+TYPE_SYNCHRO+TYPE_PENDULUM+TYPE_RITUAL+TYPE_LINK))
end

function s.indfilter(c,tpe)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(tpe)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_RITUAL+TYPE_LINK)
end

function s.refilter(e,te)
	return not (te:GetOwner():IsCode(57) and te:GetOwnerPlayer()==e:GetOwnerPlayer())
end

function s.leaveChk(c,category)
	local ex,tg=Duel.GetOperationInfo(0,category)
	return ex and tg~=nil and tg:IsContains(c)
end
function s.imfilter(e,te)
	local c=e:GetOwner()
	return ((c:GetDestination()>0 and c:GetReasonEffect()==te)
		or (s.leaveChk(c,CATEGORY_TOHAND) or s.leaveChk(c,CATEGORY_DESTROY) or s.leaveChk(c,CATEGORY_REMOVE)
		or s.leaveChk(c,CATEGORY_TODECK) or s.leaveChk(c,CATEGORY_RELEASE) or s.leaveChk(c,CATEGORY_TOGRAVE)))
		and not (te:GetHandler():IsLocation(LOCATION_EXTRA) and te:GetCode()==EFFECT_SPSUMMON_PROC) and e:GetOwner()~=te:GetOwner() and not te:GetHandler():IsCode(57)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local ex,_,damp=Duel.CheckEvent(EVENT_BATTLE_DAMAGE,true)
	return (bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and bc:IsControler(1-tp)) or (ex and damp==1-tp)
end
function s.spfilter(c,e,tp)
	if not (c:IsSetCard(SET_SUPREME_KING_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_GRAVE)
end
function s.exfilter1(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
end
function s.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function s.rescon(ft1,ft2,ft3,ft4,ft)
	return function(sg,e,tp,mg)
			local exnpct=sg:FilterCount(s.exfilter1,nil,LOCATION_EXTRA)
			local expct=sg:FilterCount(s.exfilter2,nil,LOCATION_EXTRA)
			local mct=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
			local exct=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
			local res=ft3>=exnpct and ft4>=expct and ft1>=mct
			return res,not res
		end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft4=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=math.min(Duel.GetUsableMZoneCount(tp),2)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		if ft4>0 then ft4=1 end
		ft=1
	end
	local ect=aux.CheckSummonGate(tp)
	if ect then
		ft1=math.min(ect,ft1)
		ft2=math.min(ect,ft2)
		ft3=math.min(ect,ft3)
		ft4=math.min(ect,ft4)
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_DECK+LOCATION_GRAVE end
	if ft2>0 or ft3>0 or ft4>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,loc,0,nil,e,tp)
	if #sg==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,ft,s.rescon(ft1,ft2,ft3,ft4,ft),1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end

function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local zg=eg:Filter(function(c) return not c:IsType(TYPE_TOKEN) and c:IsControler(1-tp) end,nil)
	if zg:GetCount()<1 then return end
	Duel.Overlay(e:GetHandler(), zg)
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(Duel.GetFieldGroup(tp, LOCATION_PZONE, 0), nil, REASON_EFFECT)
		Duel.BreakEffect()
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function s.zackfilter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_PENDULUM)) and c:IsAbleToRemoveAsCost()
end
function s.hofilter(c,tp,xyzc)
    return c:IsCanBeXyzMaterial(xyzc) and (c:IsCode(703) or c:IsCode(511009441) and not c:IsCode(54))
end
function s.spcheck(sg,e,tp)
	return aux.ChkfMMZ(1)(sg,e,tp,nil) and sg:GetClassCount(Card.GetType)==#sg
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.zackfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return aux.SelectUnselectGroup(g,e,tp,4,4,s.spcheck,0) and Duel.IsExistingMatchingCard(s.hofilter,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.hofilter,tp,LOCATION_ONFIELD,0,nil,tp,c)
    if mg:GetCount()<0 then return end
    c:SetMaterial(mg)
    Duel.Overlay(c, mg)
	local g=Duel.GetMatchingGroup(s.zackfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,e:GetHandler())
	local sg=aux.SelectUnselectGroup(g,e,tp,4,4,s.spcheck,1,tp,HINTMSG_REMOVE)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

function s.spfilter2(c,e,tp)
	if not (c:IsSetCard(SET_SUPREME_KING_DRAGON) or c:IsCode(13331639)) then return false end
	local zone=e:GetHandler():GetLinkedZone(tp)
	if c:IsLocation(LOCATION_HAND) then zone=zone&~0x60 end	
	local type=0
	if c:IsType(TYPE_FUSION) then type=type|TYPE_FUSION end
	if c:IsType(TYPE_SYNCHRO) then type=type|TYPE_SYNCHRO end
	if c:IsType(TYPE_XYZ) then type=type|TYPE_XYZ end
	if c:IsType(TYPE_PENDULUM) then type=type|TYPE_PENDULUM end
	if c:IsType(TYPE_LINK) then type=type|TYPE_LINK end
	if c:IsType(TYPE_RITUAL) then type=type|TYPE_RITUAL end
	if not c:IsCanBeSpecialSummoned(e,type,tp,false,false) or not c:IsType(TYPE_MONSTER) or not c:IsType(type) then return false end
	if c:IsLocation(LOCATION_HAND) then return Duel.GetLocationCount(tp,LOCATION_MZONE, tp, LOCATION_REASON_TOFIELD, zone)>0
	else return Duel.GetLocationCountFromEx(tp,tp,nil,type, zone)>0 end
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local ct=e:GetLabel()
	local ft=math.min(ct,Duel.GetUsableMZoneCount(tp))
	local ft1=Duel.GetLocationCountFromEx(tp)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ, zone)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK, zone)
	local zone2=zone&~0x60
	local ft4=Duel.GetLocationCount(tp,LOCATION_MZONE, tp, LOCATION_REASON_TOFIELD, zone2)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		if ft4>0 then ft4=1 end
		ft=1
	end
	local ect=aux.CheckSummonGate(tp)
	if ect then
		ft1 = math.min(ect, ft1)
		ft2 = math.min(ect, ft2)
		ft3 = math.min(ect, ft3)
		ft4 = math.min(ect, ft4)
	end
	local loc=0
	if ft4>0 then loc=loc+LOCATION_HAND end
	if ft1>0 or ft2>0 or ft3>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local g=Duel.GetMatchingGroup(s.spfilter2,tp,loc,0,nil,e,tp)
	if #g==0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ct,s.rescon(ft1,ft2,ft3,ft4,ft),1,tp,HINTMSG_SPSUMMON)
	if #sg==0 then return end
	for tc in aux.Next(sg) do
		local sumtype = 0
		local zone0=zone
		if tc:IsType(TYPE_FUSION) then
			sumtype = sumtype|SUMMON_TYPE_FUSION end
		if tc:IsType(TYPE_SYNCHRO) then
			sumtype = sumtype|SUMMON_TYPE_SYNCHRO end
		if tc:IsType(TYPE_XYZ) then
			sumtype = sumtype|SUMMON_TYPE_XYZ end
		if tc:IsType(TYPE_RITUAL) then
			sumtype = sumtype|SUMMON_TYPE_RITUAL end
		if tc:IsType(TYPE_LINK) then
			sumtype = sumtype|SUMMON_TYPE_LINK end
		if tc:IsLocation(LOCATION_HAND) then zone0=zone2 end
		Duel.SpecialSummonStep(tc,sumtype,tp,tp,false,false,POS_FACEUP,zone0)
	end
	Duel.SpecialSummonComplete()
	local sg2 = Duel.GetOperatedGroup()
	if #sg2<1 then return end
	sg2:ForEach(function(c) c:CompleteProcedure() end)
	local xsg = sg2:Filter(Card.IsType, nil, TYPE_XYZ)
	if xsg:GetCount()<1 then return end
	for xsc in aux.Next(xsg) do
		if not xsc:IsLocation(LOCATION_MZONE) then goto continue end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=Duel.SelectMatchingCard(tp,s.zackXyzMaterial,tp,LOCATION_ONFIELD,0,1,63,xsc)
		if #g1<1 then return end
		Duel.Overlay(xsc,g1)
		::continue::
	end
end
function s.zackXyzMaterial(c,xsc)
	return c:IsCanBeXyzMaterial(xsc) or (not c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TOKEN))
end