-- 虚无械アイン
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMING_END_PHASE)
    c:RegisterEffect(e1)

    local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetTarget(s.reptg)
	c:RegisterEffect(e9)   

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(s.con)
	e2:SetTarget(s.filter)
	e2:SetValue(0x20002)
	c:RegisterEffect(e2)

    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE, 0)
    e3:SetValue(0)
    c:RegisterEffect(e3)

    -- to Grave
    local e12 = Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id, 1))
    e12:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
    e12:SetType(EFFECT_TYPE_QUICK_O)
    e12:SetRange(LOCATION_SZONE)
    e12:SetCode(EVENT_FREE_CHAIN)
    e12:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e12:SetTarget(s.target22)
    e12:SetOperation(s.operation1)
    c:RegisterEffect(e12)

    --to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
end
s.listed_series={0x4a}
s.listed_names={36894320}

function s.valcon(e,re,r,rp)
	return (r&REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp and e:GetHandler():GetFlagEffect(id+1)==0 end
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	return true
end

function s.con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function s.filter(e,c)
	return c:IsSetCard(0x4a) and c:GetLevel()==10
end

function s.rfilter2(c)
    return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.target22(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.rfilter2, tp, LOCATION_HAND, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end
function s.operation1(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
    local cg = Duel.SelectMatchingCard(tp, s.rfilter2, tp, LOCATION_HAND, 0, 1, 1, nil)
    if cg:GetCount() == 0 then
        return
    end
    Duel.SendtoGrave(cg, REASON_EFFECT + REASON_DISCARD)
    Duel.BreakEffect()
    Duel.Draw(tp, 1, REASON_EFFECT)
end

function s.tdfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.setfilter(c)
	return c:IsCode(36894320) and c:IsSSetable()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9409625,2)) then
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
		end
	end
end