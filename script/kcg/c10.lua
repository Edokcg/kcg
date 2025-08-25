--奥利哈刚的结界（K）
local s, id = GetID()
function s.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetTarget(s.actg)
	c:RegisterEffect(e1) 
 
	local e000=Effect.CreateEffect(c)
	e000:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e000:SetType(EFFECT_TYPE_SINGLE)
	e000:SetCode(EFFECT_ULTIMATE_IMMUNE)
	c:RegisterEffect(e000) 

	local e001=Effect.CreateEffect(c)
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e001:SetType(EFFECT_TYPE_FIELD)
	e001:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)	
	e001:SetRange(LOCATION_FZONE)
	e001:SetTargetRange(LOCATION_MZONE,0)
	e001:SetTarget(s.attg)	
	e001:SetCondition(s.atktg)		
	e001:SetValue(1)	
	c:RegisterEffect(e001) 
		
	--攻击提升 
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e02=e2:Clone()
	e02:SetRange(LOCATION_GRAVE)  
	e02:SetCondition(s.speccon) 
	c:RegisterEffect(e02)    
	
	--不会被卡的效果破坏、除外、返回手牌和卡组
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(s.efilterr)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e7)
	local e104=e4:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105=e4:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106=e4:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e4:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e4:Clone()
	e108:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e108)  
	local e109=e4:Clone()
	e109:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e109)
	local e111=e4:Clone()
	e111:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e111)

	--场上存在时不能发动场地魔法卡
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(s.distg)
	c:RegisterEffect(e8)
	
	--场上存在时不能放置场地魔法卡
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SSET)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetTargetRange(1,0)
	e10:SetTarget(s.sfilter)
	c:RegisterEffect(e10)
	
	--自己场上怪兽变为暗属性怪兽
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetCode(EFFECT_ADD_ATTRIBUTE)
	e11:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e11)
    local e112=e11:Clone()
	e112:SetRange(LOCATION_GRAVE)  
	e112:SetCondition(s.speccon) 
	c:RegisterEffect(e112)  

	--destroy legends 
	local e13=Effect.CreateEffect(c)  
	e13:SetCategory(CATEGORY_TOEXTRA)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e13:SetCode(EVENT_ADJUST)  
	e13:SetRange(LOCATION_FZONE)  
	e13:SetCondition(s.adjustcon) 
	e13:SetOperation(s.adjustop)  
	c:RegisterEffect(e13)  
	local e113=e13:Clone()
	e113:SetRange(LOCATION_GRAVE)
	e113:SetCondition(s.adjustcon2) 
	c:RegisterEffect(e113)

	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(827,0))
	e15:SetType(EFFECT_TYPE_IGNITION)
	e15:SetRange(LOCATION_FZONE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e15:SetTarget(s.tg)
	e15:SetOperation(s.op)
	c:RegisterEffect(e15)

	-- local e018=Effect.CreateEffect(c)
	-- e018:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e018:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e018:SetCode(EVENT_ADJUST)
	-- e018:SetRange(LOCATION_FZONE)  
	-- e018:SetCondition(s.ttadjcon)
	-- e018:SetOperation(s.ttadj)
	--c:RegisterEffect(e018)

	local e16=Effect.CreateEffect(c)
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e16:SetCode(EVENT_LEAVE_FIELD_P) 
	e16:SetOperation(s.leaveop)
	c:RegisterEffect(e16) 

	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e19:SetCode(EFFECT_ORICA)
	e19:SetRange(LOCATION_FZONE)
	e19:SetTargetRange(1,0)
	c:RegisterEffect(e19)

	local e20=Effect.CreateEffect(c)  
	e20:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e20:SetCode(EVENT_CHAIN_END)  
	e20:SetRange(LOCATION_FZONE)  
	e20:SetOperation(s.picop)  
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)  
	e21:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e21:SetCode(EVENT_LEAVE_FIELD_P)  
	e21:SetRange(LOCATION_FZONE)  
	e21:SetOperation(s.rpicop)  
	c:RegisterEffect(e21)
end
s.listed_series={0x900}

function s.atktgfilter(c)
    return c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_SANCT_MZONE)
end	
function s.atktg(e)
    return Duel.IsExistingMatchingCard(s.atktgfilter,e:GetHandlerPlayer(),LOCATION_RMZONE,0,1,nil)
end	
function s.attg(e,c)
	return c:IsLocation(LOCATION_RSZONE) and c:IsHasEffect(EFFECT_ORICA_SZONE)
end

function s.ttfilter1(c,tp)
	local seq=c:GetSequence()
	local mc=Duel.CheckLocation(tp,LOCATION_MZONE,seq)
	local sc=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
	if c:GetTurnID()==Duel.GetTurnCount() or c:GetFlagEffect(13)>0 or c:GetSequence()>4 then return false end
	if c:IsLocation(LOCATION_RMZONE) then
		return sc
	else
		return mc and c:IsHasEffect(EFFECT_ORICA_SZONE)
	end
end
function s.ttfilter2(c,tp)
	local seq=c:GetSequence()
	local mc=Duel.CheckLocation(tp,LOCATION_MZONE,seq)
	local sc=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
	return mc and c:IsHasEffect(EFFECT_ORICA_SZONE)
end
function s.monfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_SANCT_MZONE)
end	
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		(Duel.IsExistingMatchingCard(s.ttfilter1,tp,LOCATION_RMZONE,0,1,nil,tp)) 
	or (Duel.IsExistingMatchingCard(s.ttfilter1,tp,LOCATION_RSZONE,0,1,nil,tp)) 
    end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local a=(Duel.IsExistingMatchingCard(s.ttfilter1,tp,LOCATION_RMZONE,0,1,nil,tp))
	local b=(Duel.IsExistingMatchingCard(s.ttfilter1,tp,LOCATION_RSZONE,0,1,nil,tp))
	local looc=0   
	if a and not b then looc=LOCATION_RMZONE end
	if b and not a then looc=LOCATION_RSZONE end
	if b and a then looc=LOCATION_ONFIELD end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.ttfilter1,tp,looc,0,1,1,nil,tp):GetFirst()
	if tc then
		local seq=tc:GetSequence()
		local zone=0x1<<tc:GetSequence()
		local loc=LOCATION_RMZONE
		local is_rmzone=tc:IsLocation(LOCATION_RMZONE)
		local pos=tc:GetPosition()
		if is_rmzone then
			loc=LOCATION_RSZONE
		end
		if not tc:IsHasEffect(EFFECT_ORICA_SZONE) then
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ORICA_SZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CONTROL-RESET_TURN_SET)
			tc:RegisterEffect(e1,true)
		end
		if not Duel.MoveToField(tc,tp,tp,loc,tc:GetPosition(),true,zone) then return end
		tc:RegisterFlagEffect(13,RESET_EVENT+0x1fe0000+RESET_CONTROL-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	end
end

-- function s.ttadjcon(e,tp,eg,ep,ev,re,r,rp)
-- 	return not Duel.IsExistingMatchingCard(s.monfilter,tp,LOCATION_RMZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.leavefilter,tp,LOCATION_RSZONE,0,1,nil) 
-- end
-- function s.ttadj(e,tp,eg,ep,ev,re,r,rp)
-- 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
-- 	local tc=Duel.SelectMatchingCard(tp,s.leavefilter,tp,LOCATION_RSZONE,0,1,1,nil):GetFirst()
-- 	if not Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,tc:GetPosition(),true,0x1<<tc:GetSequence()) then return end
-- 	tc:RegisterFlagEffect(13,RESET_EVENT+0x1fe0000+RESET_CONTROL-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,0)
-- 	if tc:IsLocation(LOCATION_RMZONE) and tc:IsHasEffect(EFFECT_ORICA_SZONE) then
-- 		local orica={tc:IsHasEffect(EFFECT_ORICA_SZONE)}
-- 		for _,te in ipairs(orica) do
-- 			te:Reset()
-- 		end
-- 	end
-- end

function s.leavefilter(c)
	return c:IsHasEffect(EFFECT_ORICA_SZONE)
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==nil then return end
	local ag=Duel.GetMatchingGroup(s.leavefilter,tp,LOCATION_RSZONE,0,nil)
	if ag:GetCount()<1 then return end
	local gcount=ag:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_RMZONE)   
	local g=ag:Filter(s.ttfilter2,nil,tp)
	if g:GetCount()>0 and ft>0 then
	local tempg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,tc:GetPosition(),true,0x1<<tc:GetSequence()) then goto continue end
		tc:RegisterFlagEffect(13,RESET_EVENT+0x1fe0000-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
		-- if tc:IsLocation(LOCATION_RMZONE) and tc:IsHasEffect(EFFECT_ORICA_SZONE) then
		-- 	local orica={tc:IsHasEffect(EFFECT_ORICA_SZONE)}
		-- 	for _,te in ipairs(orica) do
		-- 		te:Reset()
		-- 	end
		-- end
		tempg:AddCard(tc)
		::continue::
		tc=g:GetNext()
	end
	ag:Sub(tempg)
	end
	Duel.Destroy(ag,REASON_RULE+REASON_EFFECT)
	if c:IsOriginalCode(id) then
		c:SetCardData(1, id)
	end
end

function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end

function s.specfilter(c)
	return c:IsFaceup() and c:IsCode(574) and not c:IsDisabled()
end
function s.speccon(e)
	return Duel.IsExistingMatchingCard(s.specfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end

function s.distg(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_FIELD)
	and not te:GetOwner():IsSetCard(0x900)
end

function s.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) and not c:IsSetCard(0x900)
end

function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>0
end
function s.adjustcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>0
    and Duel.IsExistingMatchingCard(s.specfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xa1) or c:IsSetCard(0xa0)and not c:IsSetCard(0x10a1))
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
	if dg:GetCount()==0 then return end
	local dgm=dg:GetFirst()
	while dgm do
		local gc=dgm:GetMaterial()
		if Duel.SendtoDeck(dgm,nil,0,REASON_RULE+REASON_EFFECT)>0 and gc:GetCount()>0 then
			local gc1=gc:Filter(s.mgfilter,nil,e,tp)
			local gc2=gc:Filter(s.mgfilter2,nil,e,tp)
			if dgm:IsType(TYPE_FUSION) and gc1:GetCount()>0 and gc:GetCount()==gc1:GetCount() and Duel.GetLocationCount(tp,LOCATION_MZONE)>=gc1:GetCount() then
				Duel.SpecialSummon(gc1,0,tp,tp,false,false,POS_FACEUP)
            elseif dgm:IsType(TYPE_FUSION) and gc2:GetCount()>0 and gc:GetCount()==gc2:GetCount() and Duel.GetLocationCount(tp,LOCATION_SZONE)>=gc2:GetCount() then
				Duel.SSet(tp,gc2,tp,true)
			end
		end 
		dgm=dg:GetNext()
    end
end
function s.mgfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and not bit.band(c:GetReason(),0x40008)~=0x40008 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsOriginalType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.mgfilter2(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and not bit.band(c:GetReason(),0x40008)~=0x40008 
		and not c:IsOriginalType(TYPE_MONSTER) and c:IsSSetable() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function s.efilterr(e,te)
	return te and not (te:GetOwner()==e:GetOwner() or te:GetOwner():IsSetCard(0x900))
end

function s.picfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsCode(11,12)
end
function s.picop(e, tp, eg, ep, ev, re, r, rp, chk)
	local c=e:GetHandler()
	local eqg=Duel.GetMatchingGroup(s.picfilter,tp,LOCATION_SZONE,0,nil)
	if c:IsOriginalCode(id) then
		if eqg:IsExists(Card.IsCode,1,c,12) then
			c:SetCardData(1, 12)
		elseif eqg:IsExists(Card.IsCode,1,c,11) then
			c:SetCardData(1, 11)
		end
	end
end
function s.rpicop(e, tp, eg, ep, ev, re, r, rp, chk)
	local c=e:GetHandler()
	local eqg=Duel.GetMatchingGroup(s.picfilter,tp,LOCATION_SZONE,0,nil)
	eqg:Sub(eg)
	if eg:IsExists(s.picfilter,1,nil) and c:IsOriginalCode(id) then
		if not eqg:IsExists(Card.IsCode,1,c,11) and not eqg:IsExists(Card.IsCode,1,c,12) then
			c:SetCardData(1, id)
		end
		if not eqg:IsExists(Card.IsCode,1,c,11) and eqg:IsExists(Card.IsCode,1,c,12) then
			c:SetCardData(1, 12)
		end
		if not eqg:IsExists(Card.IsCode,1,c,12) and eqg:IsExists(Card.IsCode,1,c,11) then
			c:SetCardData(1, 11)
		end
	end
end