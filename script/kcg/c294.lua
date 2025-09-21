--Legendary Knight Critias
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
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e001:SetType(EFFECT_TYPE_SINGLE)
	e001:SetCode(EFFECT_OVERINFINITE_ATTACK)
	c:RegisterEffect(e001)	
	local e002=Effect.CreateEffect(c)
	e002:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e002:SetType(EFFECT_TYPE_SINGLE)
	e002:SetCode(EFFECT_OVERINFINITE_DEFENSE)
	c:RegisterEffect(e002)	
		
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

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
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetTarget(s.rmtg)
	e0:SetOperation(s.rmop)
	c:RegisterEffect(e0)

	--Activate Traps
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)

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

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=1 and 
    ((e:GetHandler()==Duel.GetAttacker() and e:GetHandler():GetBattleTarget()~=nil)
	or (e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():GetBattleTarget()~=nil))
end
function s.filter1(c,tp)
   if not c:IsType(TYPE_TRAP) or not c:IsAbleToRemove() then return false end
   local tec = {c:GetTriggerEffect()}
   local actchk = 0
   if not tec then return false end
   for _, te in ipairs(tec) do
	   local chk, aeg, aep, aev, are, ar, arp = Duel.CheckEvent(te:GetCode(), true)
	   if (chk or bit.band(te:GetCode(),EVENT_FREE_CHAIN)~=0 or bit.band(te:GetType(), EFFECT_TYPE_IGNITION) ~= 0)
	   and (te:GetTarget() == nil or te:GetTarget()(te, tp, aeg, aep, aev, are, ar, arp, 0)) 
	   and te:GetOperation() ~= nil  then
		   actchk = 1
		   break
	   end
   end
   return actchk == 1
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end 
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp):GetFirst()
    if not tc then return end
    local tec = {tc:GetTriggerEffect()}
    if not tec then return end
    local te = nil
    local acd = {}
    local ac = {}
    for _, temp in ipairs(tec) do
        local chk, aeg, aep, aev, are, ar, arp = Duel.CheckEvent(temp:GetCode(), true)
        if (chk or bit.band(temp:GetCode(),EVENT_FREE_CHAIN)~=0 or bit.band(temp:GetType(), EFFECT_TYPE_IGNITION)~=0)
        and (temp:GetTarget() == nil or temp:GetTarget()(temp, tp, aeg, aep, aev, are, ar, arp, 0)) 
        and temp:GetOperation() ~= nil  then
            table.insert(ac, temp)
            table.insert(acd, temp:GetDescription())
        end
    end
    if #ac <= 0 then return end
    Duel.BreakEffect()
    -- Duel.Hint(HINT_CARD, 0, tc:GetCode())
    if #ac == 1 then
        te = ac[1]
    elseif #ac > 1 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
        op = Duel.SelectOption(tp, table.unpack(acd))
        op = op + 1
        te = ac[op]
    end
    if not te then return end
    te:SetHandler(c)
    local tg = te:GetTarget()
    local op = te:GetOperation()
    if tg then tg(te, tp, Group.CreateGroup(), PLAYER_NONE, 0, e, REASON_EFFECT, PLAYER_NONE, 1) end
    Duel.BreakEffect()
    tc:CreateEffectRelation(te)
    Duel.BreakEffect()
    local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    if g then
        local etc = g:GetFirst()
        while etc do
            etc:CreateEffectRelation(te)
            etc = g:GetNext()
        end
    end
    if op then op(te, tp, Group.CreateGroup(), PLAYER_NONE, 0, e, REASON_EFFECT, PLAYER_NONE, 1) end
    tc:ReleaseEffectRelation(te)
    if etc then
        etc = g:GetFirst()
        while etc do
            etc:ReleaseEffectRelation(te)
            etc = g:GetNext()
        end
    end
    if c:GetEquipTarget() then
       local e2=Effect.CreateEffect(c)
       e2:SetType(EFFECT_TYPE_SINGLE)
       e2:SetCode(EFFECT_EQUIP_LIMIT)
       e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
       e2:SetValue(1)
       c:RegisterEffect(e2)
       local tec2 = {tc:GetEquipEffect()}
       for _, te in ipairs(tec2) do
           local te2 = te:Clone()
           te2:SetOwner(tc)
           te2:SetReset(RESET_EVENT+0x1fe0000)
           c:RegisterEffect(te2, true)
       end
    end
    
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0
    and bit.band(te:GetCode(),EVENT_FREE_CHAIN)==0 and bit.band(te:GetType(), EFFECT_TYPE_IGNITION)==0 and op then
       local te2 = te:Clone()
       te2:SetOwner(c)
       te2:SetRange(LOCATION_MZONE)
       if bit.band(te:GetType(), EFFECT_TYPE_ACTIVATE) ~= 0 then
            if te:GetCode()==EVENT_CHAINING then
                te2:SetType(EFFECT_TYPE_QUICK_O)
            else
                te2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
            end
       end
       te2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
       c:RegisterEffect(te2, true)
    end
end