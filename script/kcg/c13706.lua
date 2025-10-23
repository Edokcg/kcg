-- Numeron Network
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e0 = Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetOperation(s.activate)
    c:RegisterEffect(e0)

    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(41418852,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
    -- e2:SetCountLimit(1)	
    -- e2:SetCost(s.NRTcost)
    e2:SetCondition(s.NNcondition)
    e2:SetCost(s.cpcost)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
    -- e2:SetTarget(s.NNtarget)
    -- e2:SetOperation(s.NNactivate)
    c:RegisterEffect(e2)

    -- local chain = Duel.GetCurrentChain
    -- copychain = 0
    -- Duel.GetCurrentChain = function()
    --     if copychain == 1 then
    --         copychain = 0
    --         return chain() - 1
    --     else
    --         return chain()
    --     end
    -- end

    -- no remove overlay
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(13706, 7))
    e8:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e8:SetRange(LOCATION_FZONE)
    e8:SetCondition(s.rcon)
    -- e8:SetTarget(s.rtg)
    c:RegisterEffect(e8)
end
s.listed_series={0x14b}

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e0:SetValue(1)
	if Duel.GetTurnPlayer()==tp then
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
    c:RegisterEffect(e0)
end

function s.cinfilter(c)
    return c:GetFlagEffect(592) ~= 0 and not c:IsDisabled()
end

function s.NNcondition(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetMatchingGroupCount(nil, tp, LOCATION_MZONE + LOCATION_SZONE, 0, e:GetHandler()) == 0 and
               Duel.GetTurnPlayer() == 1 - tp) or Duel.GetTurnPlayer() == tp
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk == 0 then
        return e:GetHandler():GetFlagEffect(id) < 1 + e:GetHandler():GetFlagEffect(602)
    end
    e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END, 0, 1)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x14b) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
    Duel.ClearOperationInfo(0)
    e:SetCategory(te:GetCategory())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function s.NRTfilter2(c, e, tp, eg, ep, ev, re, r, rp, chain, chk)
    local te = c:GetActivateEffect()
    if not c:IsSetCard(0x14b) or not c:IsAbleToGraveAsCost() or not te then
        return
    end
    local condition = te:GetCondition()
    local cost = te:GetCost()
    local target = te:GetTarget()
    if te:GetCode() == EVENT_CHAINING then
        if chain <= 0 then
            return false
        end
        local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
        local tc = te2:GetHandler()
        local g = Group.FromCards(tc)
        local p = tc:GetControler()
        return (not condition or condition(e, tp, g, p, chain, te2, REASON_EFFECT, p)) and
                   (not cost or cost(e, tp, g, p, chain, te2, REASON_EFFECT, p, 0)) and
                   (not target or target(e, tp, g, p, chain, te2, REASON_EFFECT, p, 0))
    else
        -- if (te:GetCode()==EVENT_SPSUMMON or te:GetCode()==EVENT_SUMMON or te:GetCode()==EVENT_FLIP_SUMMON) and chk then copychain=1 end
        return (not condition or condition(e, tp, eg, ep, ev, re, r, rp)) and
                   (not cost or cost(e, tp, eg, ep, ev, re, r, rp, 0)) and
                   (not target or target(e, tp, eg, ep, ev, re, r, rp, 0))
        -- elseif te:GetCode()==e:GetCode() then
        -- 	if te:GetCode()==EVENT_SPSUMMON and chk then copychain=1 end
        -- 	return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
        -- 		and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
        -- else
        -- 	return false
    end
end
function s.NRTcost(e, tp, eg, ep, ev, re, r, rp, chk)
    -- local a=Duel.IsExistingMatchingCard(s.cinfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    local chain = Duel.GetCurrentChain()
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.NRTfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp, eg, ep, ev, re, r,
                   rp, chain) and e:GetHandler():GetFlagEffect(13706) < 1 + e:GetHandler():GetFlagEffect(602)
    end
    chain = Duel.GetCurrentChain() - 1
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.NRTfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp, eg, ep, ev, re, r,
                  rp, chain)
    if g:GetCount() > 0 then
        Duel.SendtoGrave(g, REASON_COST)
        g:KeepAlive()
        e:SetLabelObject(g)
    end
    e:GetHandler():RegisterFlagEffect(13706, RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END, 0, 1)
end
function s.NNtarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    -- not e:GetHandler():IsStatus(STATUS_CHAINING) end
    local cg = e:GetLabelObject()
    if not cg then
        return false
    end
    local tc = cg:GetFirst()
    local chain = Duel.GetCurrentChain() - 1
    if tc == nil then
        return false
    end
    local te = tc:GetActivateEffect()
    if te == nil then
        return false
    end
    local tep = tc:GetControler()
    local cost = te:GetCost()
    Duel.ClearTargetCard()
    local tg = te:GetTarget()
    e:SetDescription(te:GetDescription())
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    tc:CreateEffectRelation(te)
    if te:GetCode() == EVENT_CHAINING then
        local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
        local tc = te2:GetHandler()
        local g = Group.FromCards(tc)
        local p = tc:GetControler()
        if cost then
            cost(e, tp, g, p, chain, te2, REASON_EFFECT, p, 1)
        end
        if tg then
            tg(e, tp, g, p, chain, te2, REASON_EFFECT, p, 1)
        end
    else
        if cost then
            cost(e, tp, eg, ep, ev, re, r, rp, 1)
        end
        if tg then
            tg(e, tp, eg, ep, ev, re, r, rp, 1)
        end
    end
    local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    if gg then
        local etc = gg:GetFirst()
        while etc do
            etc:CreateEffectRelation(te)
            etc = gg:GetNext()
        end
    end
end
function s.NNactivate(e, tp, eg, ep, ev, re, r, rp)
    local cg = e:GetLabelObject()
    if not cg then
        return
    end
    local tc = cg:GetFirst()
    local chain = Duel.GetCurrentChain() - 1
    copychain = 0
    if tc then
        local te = tc:GetActivateEffect()
        local op = te:GetOperation()
        if not op then
            cg:DeleteGroup()
            local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
            if gg then
                local etc = gg:GetFirst()
                while etc do
                    etc:ReleaseEffectRelation(te)
                    etc = gg:GetNext()
                end
            end
            return
        end
        if te:GetCode() == EVENT_CHAINING then
            local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
            local tc = te2:GetHandler()
            local g = Group.FromCards(tc)
            local p = tc:GetControler()
            if op then
                op(e, tp, g, p, chain, te2, REASON_EFFECT, p)
            end
        else
            if op then
                op(e, tp, eg, ep, ev, re, r, rp)
            end
        end
        local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
        if gg then
            local etc = gg:GetFirst()
            while etc do
                etc:ReleaseEffectRelation(te)
                etc = gg:GetNext()
            end
        end
    end
    cg:DeleteGroup()
end

function s.rcon(e, tp, eg, ep, ev, re, r, rp)
    return bit.band(r, REASON_COST) ~= 0 and re:GetHandler():IsType(TYPE_XYZ) and re:GetHandler():GetControler() ==
               e:GetHandlerPlayer() and re:GetHandler():IsSetCard(0x14b)
end
function s.rtg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local ttp = c:GetControler()
    if chk == 0 then
        return true
    end
    if (re:GetHandler():GetOverlayCount() == 0 or
        (re:GetHandler():GetOverlayCount() > 0 and Duel.SelectYesNo(ttp, aux.Stringid(13706, 7)))) then
        return true
    else
        return false
    end
end
