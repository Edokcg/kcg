--Legendary Knight Hermos
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	local e001=Effect.CreateEffect(c)
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e001:SetType(EFFECT_TYPE_SINGLE)
	e001:SetCode(EFFECT_OVERINFINITE_ATTACK)
	c:RegisterEffect(e001)	
	local e002=Effect.CreateEffect(c)
	e002:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e002:SetType(EFFECT_TYPE_SINGLE)
	e002:SetCode(EFFECT_OVERINFINITE_DEFENSE)
	c:RegisterEffect(e002)	

	--cannot special summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e1:SetValue(aux.FALSE)
	-- c:RegisterEffect(e1)

	-- local e0=Effect.CreateEffect(c)
	-- e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	-- e0:SetCode(EVENT_ADJUST)
	-- e0:SetRange(LOCATION_MZONE)
	-- e0:SetCondition(s.adjustcon) 
	-- e0:SetOperation(s.adjustop)
	-- c:RegisterEffect(e0)
	
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetTarget(s.rmtg)
	e0:SetOperation(s.rmop)
	c:RegisterEffect(e0)

	  --Absorb Monster effects
	  local e2=Effect.CreateEffect(c)
	  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	  e2:SetDescription(aux.Stringid(2407234,1))
	  e2:SetType(EFFECT_TYPE_QUICK_O)
	  e2:SetCode(EVENT_FREE_CHAIN)
	  e2:SetRange(LOCATION_MZONE)
	  e2:SetCountLimit(1)
	  e2:SetCost(s.ccost)
	  e2:SetOperation(s.cop)
	  c:RegisterEffect(e2)

	--Redirect attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69937550,1))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCondition(s.cbcon)
	--e3:SetTarget(s.cbtg)
	e3:SetOperation(s.cbop)
	c:RegisterEffect(e3)

	--Divert and multiply
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000010,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.pbcon)
	e4:SetTarget(s.pbtg)
	e4:SetCost(s.pbcost)
	e4:SetOperation(s.pbop)
	c:RegisterEffect(e4)

	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_DISABLE)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e101)
	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e9)
end

-- function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.GetMatchingGroupCount(s.adfilter,tp,0,LOCATION_ONFIELD,nil)>0
-- end
-- function s.adfilter(c)
--     return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
-- end
-- function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	local g=Duel.GetMatchingGroup(s.adfilter,tp,0,LOCATION_ONFIELD,nil)
-- 	if #g>0 then
-- 		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
-- 	end
-- end

function s.rmfilter(c)
	return c:IsSpellTrap() and c:IsFaceup()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Remove(tc,POS_FACEUP,REASON_RULE+REASON_EFFECT)
	end
end

function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #tc<1 then return end
	e:SetLabelObject(tc:GetFirst())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function s.sfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemoveAsCost()
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		local reset_flag=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(tc:GetCode())
		e1:SetReset(reset_flag)
		c:RegisterEffect(e1)
		c:CopyEffect(code, reset_flag, 1)
	end
end 

function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return c~=bt and bt:GetControler()==c:GetControler() 
	and c:GetFlagEffect(294)==0 
	and c:GetFlagEffect(725)==0
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(294,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg2=Duel.GetAttackTarget()
	local tg=Duel.GetAttacker()	
	if not (tg:IsOnField() and not tg:IsStatus(STATUS_ATTACK_CANCELED)) or not tg2:IsOnField() then return end		
	Duel.ChangeAttackTarget(c)
end

function s.pbcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget() or (eg~=nil and e:GetHandler()==eg:GetFirst())
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.pbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	if #g<1 then return end
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.pbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(296,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
end
function s.pbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(296)
	if c:IsFacedown() or c:GetAttack()<1 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c:GetAttack()*e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)

	if c:GetFlagEffect(295)==0 then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(10000010,0))
		e4:SetCategory(CATEGORY_ATKCHANGE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4:SetCode(EVENT_BE_BATTLE_TARGET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(s.pbcon)
		e4:SetTarget(s.pbtg)
		e4:SetLabel(e:GetLabel())
		e4:SetOperation(s.pbop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e4) 
	end
	c:RegisterFlagEffect(295,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	if c:GetFlagEffect(295)>2 and e:GetLabel()>1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(9999999)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    end

	if c:GetFlagEffect(294)==0 and Duel.SelectYesNo(tp,aux.Stringid(69937550,1)) then 
		c:RegisterFlagEffect(725,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,c)
		local tc=g:GetFirst()
		if tc then 
			Duel.HintSelection(g) 
			Duel.ChangeAttackTarget(tc)
		 end
	end
end
