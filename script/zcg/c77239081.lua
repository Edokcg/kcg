--黑魔导·紫将
function c77239081.initial_effect(c)
    --特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239081.spcon)
    e1:SetOperation(c77239081.spop)
    c:RegisterEffect(e1)
    
    --特招
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239081.target1)
    e2:SetOperation(c77239081.activate1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    
    --equip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239081,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c77239081.eqcon)
    e4:SetTarget(c77239081.eqtg)
    e4:SetOperation(c77239081.eqop)
    c:RegisterEffect(e4)
    
    --[[装备-特招
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE) 
    e4:SetTarget(c77239081.sptg)
    e4:SetOperation(c77239081.spop2)
    c:RegisterEffect(e4)]]
end
--------------------------------------------------------------------------
function c77239081.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0     
end
function c77239081.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-500)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77239081.filter(c)
    return c:IsCode(38033121)
end
--[[function c77239081.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77239081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_DECK) and chkc:IsControler(tp) and c77239081.filter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239081.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239081.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239081.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(atk)
        tc:RegisterEffect(e2)
    end
end]]

function c77239081.filter1(c,e,tp)
    return c:IsCode(38033121) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239081.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239081.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239081.activate1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239081.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()   
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

--[[function c77239081.filter1(c,e,sp)
    return c:IsFaceup() and c:IsCode(38033121) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c77239081.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c77239081.filter1(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c77239081.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239081.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239081.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
    end
end]]

function c77239081.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239081.spfilter(c)
    return c:IsFaceup()
end
function c77239081.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239081.spfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239081.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239081.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239081.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(c77239081.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(2500)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
    --defenseup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetValue(2100)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
    --unequip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239081,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(c77239081.sptg)
    e4:SetOperation(c77239081.spop2)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e4)
end
function c77239081.eqlimit(e,c)
    return c==e:GetLabelObject()
end

function c77239081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(93108839)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    e:GetHandler():RegisterFlagEffect(93108839,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c77239081.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end