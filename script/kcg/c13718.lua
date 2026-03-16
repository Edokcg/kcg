-- CXyz Barian, the King of Wishes
local s, id = GetID()
function s.initial_effect(c)
    -- xyz summon
    Xyz.AddProcedureX(c, nil, 7, 3, nil, nil, Xyz.InfiniteMats, nil, nil, nil, s.spop)
    c:EnableReviveLimit()

    local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_XYZ_MATERIAL)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetRange(0xff&~LOCATION_MZONE)
	e01:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e01:SetTarget(s.xyztg)
	e01:SetValue(function(e,ec,rc,tp) return rc==e:GetHandler() end)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_XYZ_LEVEL)
	e02:SetValue(function(e,mc,rc) return rc==e:GetHandler() and 7,mc:GetLevel() or mc:GetLevel() end)
	c:RegisterEffect(e02)

    --atk
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    local e1 = Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(511001363)
    c:RegisterEffect(e1)
    aux.GlobalCheck(s, function()
        local ge = Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge:SetCode(EVENT_ADJUST)
        ge:SetCondition(s.con)
        ge:SetOperation(s.op)
        Duel.RegisterEffect(ge, 0)
    end)

	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
    e4:SetCost(s.copycost2)
	e4:SetOperation(s.copyop2)
	c:RegisterEffect(e4)
end
s.listed_series = {SET_NUMBER_C}

function s.xyztg(e,c)
	local no=c.xyz_number
	return c:IsFaceup() and ((no and no>=101 and no<=107 and c:IsSetCard(SET_NUMBER_C)) or c:GetLevel()==7)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    local c = e:GetHandler()
    local tg = c:GetMaterial()
    if tg:FilterCount(Card.IsCode, nil, 12744567)>0 and tg:FilterCount(Card.IsCode, nil, 67173574)>0 and tg:FilterCount(Card.IsCode, nil, 20785975)>0 and tg:FilterCount(Card.IsCode, nil, 49456901)>0 and tg:FilterCount(Card.IsCode, nil, 85121942)>0 and tg:FilterCount(Card.IsCode, nil, 55888045)>0 and tg:FilterCount(Card.IsCode, nil, 68396121)>0 then
        Duel.Hint(HINT_MUSIC,tp,aux.Stringid(828, 7))
    end
end

function s.con(e)
	return Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_ALL,LOCATION_ALL,1,e:GetOwner())
end
function s.cfilter(c)
    local chk=false
    local effs={c:GetOwnEffects()}
    for _,te in ipairs(effs) do
        if te:GetCode()==EFFECT_RANKUP_EFFECT then te=te:GetLabelObject() end
        if te:HasDetachCost() then chk=true end
    end
    return chk and c:GetFlagEffect(5110013630)==0
end
function s.op(e)
    local g = Duel.GetMatchingGroup(s.cfilter, 0, LOCATION_ALL, LOCATION_ALL, e:GetOwner())
    for c in aux.Next(g) do
        local effs={c:GetOwnEffects()}
        for _,te in ipairs(effs) do
            if te:GetCode()==EFFECT_RANKUP_EFFECT then te=te:GetLabelObject() end
            if te:HasDetachCost() then
                local resetflag,resetcount=te:GetReset()
                local rm,max,code,flag,hopt=te:GetCountLimit()
                local category = te:GetCategory()
                local prop1,prop2=te:GetProperty()
                local label = te:GetLabel()
                local e1 = Effect.CreateEffect(e:GetOwner())
                if te:GetDescription() then
                    e1:SetDescription(te:GetDescription())
                end
                e1:SetLabelObject(te)
                e1:SetType(EFFECT_TYPE_XMATERIAL+te:GetType()&(~EFFECT_TYPE_SINGLE))
                if te:GetCode()>0 then
                    e1:SetCode(te:GetCode())
                end
                e1:SetCategory(category)
                e1:SetProperty(prop1,prop2)
                if label then
                    e1:SetLabel(label)
                end
                e1:SetCondition(s.copycon)
                e1:SetCost(s.copycost)
                if max > 0 then
                    e1:SetCountLimit(max,{code,hopt}, flag)
                end
                if te:GetTarget() then
                    e1:SetTarget(te:GetTarget())
                end
                if te:GetOperation() then
                    e1:SetOperation(te:GetOperation())
                end
                if resetflag>0 and resetcount>0 then
                    e1:SetReset(resetflag, resetcount)
                elseif resetflag>0 then
                    e1:SetReset(resetflag)
                end
                c:RegisterEffect(e1, true)
            end
            c:RegisterFlagEffect(5110013630,0,0,1)
        end
        if c:GetRealCode()==0 then c:RegisterFlagEffect(5110013630,0,0,1) end
    end
end
function s.copycon(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetLabelObject() then return false end
    local te=e:GetLabelObject()
    local con = te:GetCondition()
    return e:GetHandler():IsHasEffect(511001363) 
    and te:GetOwner():GetFlagEffect(id) == 0 
    and (not con or con(e, tp, eg, ep, ev, re, r, rp))
end
function s.copycost(e, tp, eg, ep, ev, re, r, rp, chk)
    if not e:GetLabelObject() then return false end
    local c=e:GetHandler()
    local te=e:GetLabelObject()
	local tc=te:GetOwner()
    local cost=te:GetCost()
	local a=c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b=Duel.CheckLPCost(tp,400)
    local ov=c:GetOverlayGroup()
    if chk == 0 then
        return (a or b) and (cost == nil or cost(e, tp, eg, ep, ev, re, r, rp, 0))
    end
    Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
    local op=Duel.SelectEffect(tp,{a,aux.Stringid(81330115,0)},{b,aux.Stringid(41925941,1)})
	if op==1 then
		Duel.SendtoGrave(tc,REASON_COST)
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,tp,0)
	else
		Duel.PayLPCost(tp,400)
	end
    tc:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
    if te:GetLabelObject() then
        te:SetLabelObject(te:GetLabelObject())
    end
end

function s.atkval(e, c)
    return c:GetOverlayCount() * 1000
end

function s.cfilter2(c)
    return c:GetFlagEffect(id)==0 and c:IsSetCard(0x48) and c:IsType(TYPE_EFFECT)
end
function s.copycost2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():FilterCount(s.cfilter2,nil)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
	local sc=c:GetOverlayGroup():FilterSelect(tp,s.cfilter2,1,1,nil,e,tp):GetFirst()
    Duel.SendtoGrave(sc,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,tp,0)
    e:SetLabelObject(sc)
end
function s.copyop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc then
		local code=tc:GetOriginalCode()
		--This card's name becomes the target's name
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetLabel(tp)
		e1:SetReset(RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		--Replace this card's effect with that monster's original effect
		local cid=c:CopyEffect(code,RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		--Reset the effects manually at the End Phase of the opponent's next turn
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,4))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.resetcon)
		e2:SetOperation(s.resettop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	end
end
function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabelObject():GetLabel()
	return Duel.IsTurnPlayer(1-p)
end
function s.resettop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
