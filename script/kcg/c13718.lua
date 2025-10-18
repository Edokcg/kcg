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
        local ge = Effect.GlobalEffect()
        ge:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge:SetCode(EVENT_ADJUST)
        ge:SetCondition(s.con)
        ge:SetOperation(s.op)
        Duel.RegisterEffect(ge, 0)
    end)

	--copy
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(aux.Stringid(67926903,1))
	-- e4:SetType(EFFECT_TYPE_IGNITION)
	-- e4:SetRange(LOCATION_MZONE)
	-- e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e4:SetCountLimit(1)
	-- e4:SetTarget(s.copytg)
	-- e4:SetOperation(s.copyop)
	-- c:RegisterEffect(e4)    
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
        if te:GetCode()&511001822==511001822 or te:GetLabel()==511001822 then te=te:GetLabelObject() end
        if te:HasDetachCost() then chk=true end
    end
    return chk and c:GetFlagEffect(5110013630)==0
end
function s.op(e)
    local g = Duel.GetMatchingGroup(s.cfilter, 0, LOCATION_ALL, LOCATION_ALL, e:GetOwner())
    for c in aux.Next(g) do
        local effs={c:GetOwnEffects()}
        for _,te in ipairs(effs) do
            if te:GetCode()&511001822==511001822 or te:GetLabel()==511001822 then te=te:GetLabelObject() end
            if te:HasDetachCost() then
                local resetflag,resetcount=te:GetReset()
                local rm,max,code,flag,hopt=te:GetCountLimit()
                local category = te:GetCategory()
                local prop1,prop2=te:GetProperty()
                local label = te:GetLabel()
                local e1 = Effect.CreateEffect(c)
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
    local con = e:GetLabelObject():GetCondition()
    return e:GetHandler():IsHasEffect(511001363) 
    and e:GetOwner():GetFlagEffect(id) == 0 
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
	else
		Duel.PayLPCost(tp,400)
	end
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    if te:GetLabelObject() then
        te:SetLabelObject(te:GetLabelObject())
    end
end

function s.atkval(e, c)
    return c:GetOverlayCount() * 1000
end

-- function s.afilter(c)
-- 	return c:IsSetCard(0x48) and c:IsType(TYPE_EFFECT)
-- end
-- function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
-- 	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.afilter(chkc) end
-- 	if chk==0 then return Duel.IsExistingTarget(s.afilter,tp,LOCATION_GRAVE,0,1,nil) end
-- 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
-- 	Duel.SelectTarget(tp,s.afilter,tp,LOCATION_GRAVE,0,1,1,nil)
-- end
-- function s.copyop(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	local tc=Duel.GetFirstTarget()
-- 	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
-- 		local code=tc:GetOriginalCode()
-- 		local e1=Effect.CreateEffect(c)
-- 		e1:SetType(EFFECT_TYPE_SINGLE)
-- 		e1:SetCode(EFFECT_CHANGE_CODE)
-- 		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
-- 		e1:SetValue(code)
-- 		e1:SetLabel(tp)
-- 		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
-- 		c:RegisterEffect(e1)
-- 		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
-- 	end
-- end