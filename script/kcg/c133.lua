--神炎皇 乌利亚（AC）
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
		local e02=Effect.CreateEffect(c)
		e02:SetType(EFFECT_TYPE_SINGLE)
		e02:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e02:SetRange(LOCATION_MZONE)
		e02:SetCode(EFFECT_SELF_DESTROY)
		e02:SetCondition(s.descon)
		c:RegisterEffect(e02)
	
	--攻守为墓地陷阱卡数量
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--破坏对方场上1张魔法陷阱
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10000024,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	
	--不受陷阱效果以及魔法效果怪兽生效一回合
	local e82 = Effect.CreateEffect(c)
    e82:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e82:SetCode(EVENT_CHAIN_SOLVED)
    e82:SetRange(LOCATION_MZONE)
    e82:SetCondition(s.sdcon2)
    e82:SetOperation(s.sdop2)
    c:RegisterEffect(e82)
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilterr)
	c:RegisterEffect(e4)

	local te=Effect.CreateEffect(c)
	te:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	te:SetRange(LOCATION_MZONE)
	te:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	te:SetCountLimit(1)
	te:SetCode(EVENT_PHASE+PHASE_END)	
	te:SetOperation(s.reop2)	
	c:RegisterEffect(te)	
	
	--不能成为对方的卡的效果对象
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.tgvalue)
	--c:RegisterEffect(e5)
	
	--丢弃手牌陷阱卡后墓地特殊召唤
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetOperation(s.rop)
	--c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10000024,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1)
	e7:SetCost(s.fcost)
	e7:SetTarget(s.ftg)
	e7:SetOperation(s.fop)
	c:RegisterEffect(e7)
end
s.listed_names={27564031,6007213}

function s.spfilter(c)
		return c:IsCode(6007213) and c:IsAbleToGraveAsCost()
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

function s.atkfilter(c)
	return c:IsType(TYPE_TRAP) 
end

function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end

function s.desfilter(c)
	return c:IsFacedown() and c:GetSequence()~=5
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,s.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then return end
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_TRAP) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.RaiseSingleEvent(c,133,e,0,tp,tp,0)
		end
	end
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

function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end

function s.costfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPreviousPosition()
	if c:IsReason(REASON_BATTLE) then pos=c:GetBattlePosition() end
	if rp~=tp and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY)
	and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(pos,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(133,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function s.fcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCondition(c10000024.atcon)
		c:RegisterEffect(e2)
	end
end

function s.atcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end