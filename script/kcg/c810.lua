local s, id = GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(s.condition) 
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e19:SetCode(EFFECT_SANCT)
	e19:SetRange(LOCATION_FZONE)
	e19:SetTargetRange(1,0)
	c:RegisterEffect(e19)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.egcon)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)

	--维持代价
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)

	--重置怨灵
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.mtcon1)
	e4:SetOperation(s.mtop1)
	c:RegisterEffect(e4)
	
	--补充怨灵
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.mtcon2)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
	  	
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(s.condition2)
	c:RegisterEffect(e7)

	--不会被卡的效果破坏、除外、返回手牌和卡组
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetValue(s.efilterr)
	c:RegisterEffect(e6)
end
s.listed_names={812}
----------------------------------------------------------------------
function s.cfilter(c)
	return c:GetLevel()==8 and c:IsRace(RACE_FIEND)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
		local token=Duel.CreateToken(1-tp,812)
		if not Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then return end
		token:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsFaceup() then
			s.activate2(e,tp,token,tc)
		end
	end
end
function s.activate2(e,tp,token,tc)
	Duel.RaiseEvent(Group.FromCards(token,tc),EVENT_EQUIP,e,REASON_EFFECT,tp,tp,0)
	local e1=Effect.CreateEffect(token)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(810)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(token)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	--攻击无效
	local e6=Effect.CreateEffect(token)
	e6:SetDescription(aux.Stringid(36378044,0))
	e6:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetLabel(1)
	e6:SetCondition(s.atkcon)
	e6:SetOperation(s.atkop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e6)
	local e2=Effect.CreateEffect(token)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(function(ae) e1:Reset() ae:Reset() end)
	token:RegisterEffect(e2,true)   
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)  
	token:RegisterEffect(e3,true)   
	local e4=Effect.CreateEffect(token)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(function(ae) Duel.Destroy(token,REASON_RULE) end)
	--e4:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e4,true)  
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHANGE_POS)  
	e5:SetCondition(function(...) return tc:IsFacedown() end)
	--e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET) 
	tc:RegisterEffect(e5,true)  
	--Duel.Hint(HINT_CARD,tp,tc:GetCode())--确认
	--Duel.ConfirmCards(tp,tc)--确认
end

function s.egcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
----------------------------------------------------------------------
function s.gfilter(c)
	return c:IsCode(812) and c:IsFaceup() and c:GetFlagEffect(id)~=0
end
function s.gfilter2(c,tc)
	if c:IsFacedown() then return false end
	local peffs={c:GetCardEffect(810)}
	for _, eff in ipairs(peffs) do
		if eff:GetLabelObject()==tc then return true end
	end
	return false
end
local equipg=Card.GetEquipGroup
function Card.GetEquipGroup(c)
	local token=Duel.GetMatchingGroup(s.gfilter,0,LOCATION_SZONE,LOCATION_SZONE,nil)
	local mg=equipg(c)
	for tc in aux.Next(token) do
		if s.gfilter2(c,tc) then mg:Merge(token) end
	end
	return mg
end
local equipgc=Card.GetEquipCount
function Card.GetEquipCount(c)
	return c:GetEquipGroup():GetCount()
end
local equiptg=Card.GetEquipTarget
function Card.GetEquipTarget(c)
	local tg=Duel.GetMatchingGroup(s.gfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	if s.gfilter(c) and tg:GetCount()>0 then return tg:GetFirst()
	else return equiptg(c) end
end
----------------------------------------------------------------------
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,nil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(78371393,2)) then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
----------------------------------------------------------------------
function s.mtcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(s.gfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup, 0, LOCATION_MZONE, 0, 1, nil)
end
function s.mtop1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #token<1 then return end
	for tc in aux.Next(token) do
		local g=tc:GetEquipTarget()
		if g~=nil then
		aux.ResetEffects(Group.FromCards(g),810) end
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if g2:GetCount()>0 then
			local sg=g2:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			if sc:IsFaceup() then
				s.activate2(e,tp,tc,sc) 
			end
		end
	end
end
----------------------------------------------------------------------
function s.mtcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(s.gfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)==0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
end
----------------------------------------------------------------------
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	if not tg:IsHasEffect(810) then return false end
	local peffs={tg:GetCardEffect(810)}
	for _, eff in ipairs(peffs) do
		if eff:GetLabelObject() then return true end
	end
	return false
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	if not tg:IsHasEffect(810) or tg:IsImmuneToEffect(e) then return end
	local peffs={tg:GetCardEffect(810)}
	for _, eff in ipairs(peffs) do
		if eff:GetLabelObject() and Duel.NegateAttack() then
			Duel.Damage(tg:GetControler(),tg:GetAttack()/2,REASON_EFFECT)
			Duel.Recover(1-tg:GetControler(),tg:GetAttack()/2,REASON_EFFECT)
			return
		end
	end
end

function s.efilterr(e,te)
	return te:GetOwner()~=e:GetOwner()
end