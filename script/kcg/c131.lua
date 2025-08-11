--奥西里斯之天空龙（AC）
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop)
		c:RegisterEffect(e1)

		--selfdes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SELF_DESTROY)
		e2:SetCondition(s.descon)
		c:RegisterEffect(e2)

		--spson
		local e21=Effect.CreateEffect(c)
		e21:SetType(EFFECT_TYPE_SINGLE)
		e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e21:SetCode(EFFECT_SPSUMMON_CONDITION)
		e21:SetValue(aux.FALSE)
		c:RegisterEffect(e21)

	-- local te=Effect.CreateEffect(c)
	-- te:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- te:SetRange(LOCATION_MZONE)
	-- te:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- te:SetCountLimit(1)
	-- te:SetCode(EVENT_PHASE+PHASE_END)	
	-- te:SetOperation(s.reop2)	
	-- c:RegisterEffect(te)		
	
	--召唤后攻守数值
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	
	--下降对手怪兽攻击、破坏
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetDescription(aux.Stringid(10000022,2))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(10)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCondition(s.atkcon)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
s.listed_names={27564031,10000020}

function s.spfilter(c)
		return c:IsCode(10000020) and c:IsAbleToGraveAsCost()
end
function s.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
				and Duel.IsExistingMatchingCard(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,3,nil,0x23)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if #tg<1 then return end
		Duel.SendtoGrave(tg,REASON_COST)
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end

function s.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP) 
	--and (not e or c:IsRelateToEffect(e)) 
--and not c:IsRace(RACE_CREATORGOD)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.atkfilter,1,nil,1-tp)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.atkfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg:Filter(s.atkfilter,nil,1-tp))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		if tc:GetPosition()==POS_FACEUP_ATTACK and preatk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetAttack()==0 then dg:AddCard(tc) end end

		if tc:GetPosition()==POS_FACEUP_DEFENSE and predef>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetDefense()==0 then dg:AddCard(tc) end end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT) end
end

function s.deffilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_DEFENSE) and (not e or c:IsRelateToEffect(e)) 
--and not c:IsRace(RACE_CREATORGOD)
end
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.deffilter,1,nil,nil,1-tp)
end
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.deffilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetDefense()==0 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_RULE+REASON_EFFECT)
end

function s.efilterr(e, te)
    local c = e:GetHandler()
    local tc = te:GetOwner()
    if tc == e:GetOwner() or te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) then
        return false
    else
        return te:IsActiveType(TYPE_TRAP)
        --   or ((te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_SPELL)) and tc~=e:GetOwner())
        --    and ((te:GetType()==EFFECT_TYPE_FIELD and not (tc:GetTurnID()>=Duel.GetTurnCount() or (tc:GetFlagEffect(818)~=0 and tc:GetFlagEffectLabel(818)==c:GetFieldID())) )
        -- 	 or te:GetType()==EFFECT_TYPE_EQUIP and Duel.GetTurnCount()-tc:GetTurnID()>=1))
    end
end

function s.sdcon2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = re:GetHandler()
    local eff=0
    for i = 1, 522 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if tc~=c and te:GetOwner()==tc and (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP) and te:GetHandler()==c and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE)
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then 
                    eff=1
                    break 
                end
            end
        end
    end
    return eff==1
end
function s.sdop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = re:GetHandler()
    local eff=0
    for i = 1, 522 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if tc~=c and te:GetOwner()==tc and (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP) and te:GetHandler()==c and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE)
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then 
                    eff=te
                    break 
                end
            end
        end
    end
    if eff==0 then return end
    local e83 = Effect.CreateEffect(c)
    e83:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e83:SetRange(LOCATION_MZONE)
    e83:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e83:SetCountLimit(1)
    e83:SetCode(EVENT_PHASE + PHASE_END)
    e83:SetLabelObject(eff)
    e83:SetOperation(s.setop2)
    e83:SetReset(RESET_PHASE + PHASE_END)
    c:RegisterEffect(e83) 
end
function s.setop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local te = e:GetLabelObject()
    if not te or te==0 then return end
    te:Reset()
end   

function s.reop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    for i = 1, 430 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if te:GetOwner() ~= e:GetOwner() 
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then
                    if te:GetType() == EFFECT_TYPE_FIELD then
                        local e80 = Effect.CreateEffect(c)
                        e80:SetType(EFFECT_TYPE_SINGLE)
                        e80:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
                        e80:SetRange(LOCATION_MZONE)
                        e80:SetCode(EFFECT_IMMUNE_EFFECT)
                        e80:SetValue(function(e, te2)
                            return te2 == te
                        end)
                        e80:SetReset(RESET_EVENT + 0x1fe0000)
                        c:RegisterEffect(e80)
                    elseif (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP or te:GetType()==EFFECT_TYPE_GRANT or te:GetType()==EFFECT_TYPE_XMATERIAL)
					and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
                    and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
                        te:Reset()
                    end
                end
            end
        end
    end
    for i = 2000, 2030 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if te:GetOwner() ~= e:GetOwner() 
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then
                    if te:GetType() == EFFECT_TYPE_FIELD then
                        local e80 = Effect.CreateEffect(c)
                        e80:SetType(EFFECT_TYPE_SINGLE)
                        e80:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
                        e80:SetRange(LOCATION_MZONE)
                        e80:SetCode(EFFECT_IMMUNE_EFFECT)
                        e80:SetValue(function(e, te2)
                            return te2 == te
                        end)
                        e80:SetReset(RESET_EVENT + 0x1fe0000)
                        c:RegisterEffect(e80)
                    elseif (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP or te:GetType()==EFFECT_TYPE_GRANT or te:GetType()==EFFECT_TYPE_XMATERIAL)
					and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
                    and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
                        te:Reset()
                    end
                end
            end
        end
    end
end

function s.atcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end

function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end

function s.lffilter(e,re,rp)
	return re:GetOwner()~=e:GetHandler() 
end