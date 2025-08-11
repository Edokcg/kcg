--天神战击集约(ZCG)
function c77239694.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
	
    -- xyzop
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c77239694.xyzcon)
    e2:SetOperation(c77239694.xyzop)
    e2:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e2)

    --equip
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239694,1))
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c77239694.cost)
    e3:SetTarget(c77239694.eqtg)
    e3:SetOperation(c77239694.eqop)
    c:RegisterEffect(e3)

    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239694,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_CONFIRM)
    e4:SetCondition(c77239694.descon)
    e4:SetOperation(c77239694.desop)
    c:RegisterEffect(e4)	
end
------------------------------------------------------------------
function c77239694.hofilter(c,tp,xyzc)
    if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
    return c:IsCanBeXyzMaterial(xyzc)
end
function c77239694.xyzcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
    return Duel.IsExistingMatchingCard(c77239694.hofilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,c)
end
function c77239694.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239694.hofilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp,c)
    if mg:GetCount()<0 then return end
    c:SetMaterial(mg)
    Duel.Overlay(c, mg)
end
------------------------------------------------------------------
function c77239694.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239694.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239694.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77239694.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
		    if not Duel.Equip(tp,tc,c,false) then return end
		    local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c77239694.eqlimit)
            tc:RegisterEffect(e1)
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
------------------------------------------------------------------
function c77239694.filter(c,att)
	return c:IsFaceup() and c:IsFaceup() and c:IsAttribute(att) and c:IsDestructable()
end
function c77239694.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not Duel.GetAttacker() and not Duel.GetAttackTarget() then return end
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	local eg=e:GetHandler():GetEquipGroup()
	local att=a:GetAttribute()
	e:SetLabelObject(a)
	return a and a:IsRelateToBattle()and eg:IsExists(Card.IsAttribute,1,nil,att)
end
function c77239694.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject(a)
	if tc:IsFacedown() or not tc:IsRelateToBattle() then return end
	local g=Duel.GetMatchingGroup(c77239694.filter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	if g:GetCount()>0 then
	    Duel.Destroy(g,REASON_EFFECT)
	end
end



